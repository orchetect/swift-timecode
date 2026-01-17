//
//  FrameCount Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

@testable import SwiftTimecodeCore
import Testing

@Suite struct FrameCount_Tests {
    @Test
    func init_frameCount() async {
        let subFramesBase: Timecode.SubFramesBase = .max80SubFrames
        
        let fc = Timecode.FrameCount(
            subFrameCount: 40002,
            base: subFramesBase
        )
        
        #expect(fc.wholeFrames == 500)
        #expect(fc.subFrames == 2)
        #expect(fc.doubleValue == 500.025)
        #expect(fc.subFrameCount == 40002)
    }
    
    @Test
    func equatable() async {
        // .frames
        
        #expect(
            Timecode.FrameCount(.frames(500), base: .max100SubFrames)
                == Timecode.FrameCount(.frames(500), base: .max100SubFrames)
        )
        
        #expect(
            Timecode.FrameCount(.frames(500), base: .max100SubFrames)
                != Timecode.FrameCount(.frames(501), base: .max100SubFrames)
        )
        
        // .split
        
        #expect(
            Timecode.FrameCount(.split(frames: 500, subFrames: 2), base: .max100SubFrames)
                == Timecode.FrameCount(.split(frames: 500, subFrames: 2), base: .max100SubFrames)
        )
        
        #expect(
            Timecode.FrameCount(.split(frames: 500, subFrames: 2), base: .max100SubFrames)
                != Timecode.FrameCount(.split(frames: 500, subFrames: 3), base: .max100SubFrames)
        )
        
        // .combined
        
        #expect(
            Timecode.FrameCount(.combined(frames: 500.025), base: .max100SubFrames)
                == Timecode.FrameCount(.combined(frames: 500.025), base: .max100SubFrames)
        )
        
        #expect(
            Timecode.FrameCount(.combined(frames: 500.025), base: .max100SubFrames)
                != Timecode.FrameCount(.combined(frames: 500.5), base: .max100SubFrames)
        )
        
        // .splitUnitInterval
        
        #expect(
            Timecode.FrameCount(
                .splitUnitInterval(frames: 500, subFramesUnitInterval: 0.025),
                base: .max100SubFrames
            )
                == Timecode.FrameCount(
                    .splitUnitInterval(frames: 500, subFramesUnitInterval: 0.025),
                    base: .max100SubFrames
                )
        )
        
        #expect(
            Timecode.FrameCount(
                .splitUnitInterval(frames: 500, subFramesUnitInterval: 0.025),
                base: .max100SubFrames
            )
                == Timecode.FrameCount(.combined(frames: 500.025), base: .max100SubFrames)
        )
        
        #expect(
            Timecode.FrameCount(
                .splitUnitInterval(frames: 500, subFramesUnitInterval: 0.025),
                base: .max100SubFrames
            )
                != Timecode.FrameCount(
                    .splitUnitInterval(frames: 500, subFramesUnitInterval: 0.5),
                    base: .max100SubFrames
                )
        )
        
        #expect(
            Timecode.FrameCount(
                .splitUnitInterval(frames: 500, subFramesUnitInterval: 0.025),
                base: .max100SubFrames
            )
                != Timecode.FrameCount(.combined(frames: 500.5), base: .max100SubFrames)
        )
    }
    
    @Test
    func operators() async {
        #expect(
            Timecode.FrameCount(.frames(200), base: .max100SubFrames)
                + Timecode.FrameCount(.frames(200), base: .max100SubFrames)
                == Timecode.FrameCount(.frames(400), base: .max100SubFrames)
        )

        #expect(
            Timecode.FrameCount(.frames(400), base: .max100SubFrames)
                - Timecode.FrameCount(.frames(200), base: .max100SubFrames)
                == Timecode.FrameCount(.frames(200), base: .max100SubFrames)
        )
        
        #expect(
            Timecode.FrameCount(.frames(200), base: .max100SubFrames)
                * 2
                == Timecode.FrameCount(.frames(400), base: .max100SubFrames)
        )
        
        #expect(
            Timecode.FrameCount(.frames(400), base: .max100SubFrames)
                / 2
                == Timecode.FrameCount(.frames(200), base: .max100SubFrames)
        )
    }
    
    @Test
    func isNegative() async {
        #expect(!Timecode.FrameCount(.frames(0), base: .max100SubFrames).isNegative)
        #expect(!Timecode.FrameCount(.frames(-0), base: .max100SubFrames).isNegative)
        
        #expect(!Timecode.FrameCount(.frames(1), base: .max100SubFrames).isNegative)
        #expect(Timecode.FrameCount(.frames(-1), base: .max100SubFrames).isNegative)
    }
    
    @Test
    func timecode_framesToSubFrames() async {
        #expect(
            Timecode.framesToSubFrames(frames: 500, subFrames: 2, base: .max80SubFrames)
                == 40002
        )
    }
    
    @Test
    func timecode_subFramesToFrames() async {
        let converted = Timecode.subFramesToFrames(40002, base: .max80SubFrames)
        
        #expect(converted.frames == 500)
        #expect(converted.subFrames == 2)
    }
    
    @Test
    func edgeCases_2997d() async throws {
        let totalFramesin24Hr = 2_589_408
        let totalSubFramesin24Hr = 207_152_640
        
        #expect(
            try Timecode(
                .frames(totalFramesin24Hr - 1),
                at: .fps29_97d,
                base: .max80SubFrames,
                limit: .max24Hours
            ).components
                == Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: 29, sf: 0)
        )
        
        #expect(
            try Timecode(
                .frames(totalFramesin24Hr - 1, subFrames: 79),
                at: .fps29_97d,
                base: .max80SubFrames,
                limit: .max24Hours
            ).components
                == Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: 29, sf: 79)
        )
        
        #expect(
            try Timecode(
                .frames(totalFramesin24Hr - 1, subFrames: 79),
                at: .fps29_97d,
                base: .max80SubFrames,
                limit: .max24Hours
            )
            .frameCount
            .subFrameCount
                == totalSubFramesin24Hr - 1
        )
    }
    
    @Test
    func edgeCases_30d() async throws {
        let totalFramesin24Hr = 2_589_408
        
        #expect(
            try Timecode(
                .frames(totalFramesin24Hr),
                at: .fps30d,
                limit: .max100Days
            ).components
                == Timecode.Components(d: 1)
        )
    }
}
