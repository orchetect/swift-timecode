//
//  Timecode FrameCount Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore // do NOT import as @testable in this file
import Testing

@Suite struct Timecode_Source_FrameCount_Tests {
    @Test
    func timecode_init_FrameCount_Exactly() async throws {
        let tc = try Timecode(
            .frames(Timecode.FrameCount(.frames(670_907), base: .max80SubFrames)),
            at: .fps30
        )
        
        #expect(tc.components == Timecode.Components(d: 00, h: 06, m: 12, s: 43, f: 17, sf: 00))
    }
    
    @Test
    func timecode_init_FrameCount_Clamping() async {
        let tc = Timecode(
            .frames(Timecode.FrameCount(
                .frames(2_073_600 + 86400), // 25 hours @ 24fps
                base: .max80SubFrames
            )),
            at: .fps24,
            by: .clamping
        )
        
        #expect(
            tc.components
            == Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    @Test
    func timecode_init_FrameCount_Wrapping() async {
        let tc = Timecode(
            .frames(Timecode.FrameCount(
                .frames(2073600 + 86400), // 25 hours @ 24fps
                base: .max80SubFrames
            )),
            at: .fps24,
            by: .wrapping
        )
        
        #expect(tc.components == Timecode.Components(h: 01))
    }
    
    @Test
    func timecode_init_FrameCount_RawValues() async {
        let tc = Timecode(
            .frames(Timecode.FrameCount(
                .frames((2073600 * 2) + 86400), // 2 days + 1 hour @ 24fps
                base: .max80SubFrames
            )),
            at: .fps24,
            by: .allowingInvalid
        )
        
        #expect(tc.components == Timecode.Components(d: 2, h: 01))
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func allFrameRates_maxTotalFrames(frameRate: TimecodeFrameRate) async {
        // duration of 24 hours elapsed, rolling over to 1 day
        
        // also helps ensure Strideable `.distance(to:)` returns the correct values
        
        // max frames in 24 hours
        let maxFramesIn24hours = switch frameRate {
        case .fps23_976: 2_073_600
        case .fps24: 2_073_600
        case .fps24_98: 2_160_000
        case .fps25: 2_160_000
        case .fps29_97: 2_592_000
        case .fps29_97d: 2_589_408
        case .fps30: 2_592_000
        case .fps30d: 2_589_408
        case .fps47_952: 4_147_200
        case .fps48: 4_147_200
        case .fps50: 4_320_000
        case .fps59_94: 5_184_000
        case .fps59_94d: 5_178_816
        case .fps60: 5_184_000
        case .fps60d: 5_178_816
        case .fps90: 7_776_000
        case .fps95_904: 8_294_400
        case .fps96: 8_294_400
        case .fps100: 8_640_000
        case .fps119_88: 10_368_000
        case .fps119_88d: 10_357_632
        case .fps120: 10_368_000
        case .fps120d: 10_357_632
        }
        
        #expect(frameRate.maxTotalFrames(in: .max24Hours) == maxFramesIn24hours)
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func allFrameRates_maxTotalFramesExpressible(frameRate: TimecodeFrameRate) async {
        // number of total elapsed frames in (24 hours - 1 frame), or essentially the maximum timecode expressible for each frame rate
        
        // max frames in 24 hours - 1
        let maxFramesExpressibleIn24hours = switch frameRate {
        case .fps23_976: 2_073_600 - 1
        case .fps24: 2_073_600 - 1
        case .fps24_98: 2_160_000 - 1
        case .fps25: 2_160_000 - 1
        case .fps29_97: 2_592_000 - 1
        case .fps29_97d: 2_589_408 - 1
        case .fps30: 2_592_000 - 1
        case .fps30d: 2_589_408 - 1
        case .fps47_952: 4_147_200 - 1
        case .fps48: 4_147_200 - 1
        case .fps50: 4_320_000 - 1
        case .fps59_94: 5_184_000 - 1
        case .fps59_94d: 5_178_816 - 1
        case .fps60: 5_184_000 - 1
        case .fps60d: 5_178_816 - 1
        case .fps90: 7_776_000 - 1
        case .fps95_904: 8_294_400 - 1
        case .fps96: 8_294_400 - 1
        case .fps100: 8_640_000 - 1
        case .fps119_88: 10_368_000 - 1
        case .fps119_88d: 10_357_632 - 1
        case .fps120: 10_368_000 - 1
        case .fps120d: 10_357_632 - 1
        }
        
        #expect(frameRate.maxTotalFramesExpressible(in: .max24Hours) == maxFramesExpressibleIn24hours)
    }
    
    @Test
    func setTimecodeExactly() async throws {
        // this is not meant to test the underlying logic, simply that `.set()` produces the intended outcome
        
        var tc = Timecode(.zero, at: .fps30, base: .max80SubFrames)
        
        try tc.set(.frames(Timecode.FrameCount(
            .frames(670_907),
            base: .max80SubFrames
        )))
        
        #expect(tc.components == Timecode.Components(d: 00, h: 06, m: 12, s: 43, f: 17, sf: 00))
    }
    
    @Test
    func setTimecodeFrameCount_Clamping() async {
        var tc = Timecode(.zero, at: .fps24, base: .max80SubFrames)
        
        tc.set(
            .frames(Timecode.FrameCount(
                .frames(2_073_600 + 86400), // 25 hours @ 24fps
                base: .max80SubFrames
            )),
            by: .clamping
        )

        #expect(
            tc.components
            == Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    @Test
    func setTimecodeFrameCount_Wrapping() async {
        var tc = Timecode(.zero, at: .fps24, base: .max80SubFrames)
        
        tc.set(
            .frames(Timecode.FrameCount(
                .frames(2073600 + 86400), // 25 hours @ 24fps
                base: .max80SubFrames
            )),
            by: .wrapping
        )
        
        #expect(tc.components == Timecode.Components(h: 01))
    }

    @Test
    func setTimecodeFrameCount_RawValues()async {
        var tc = Timecode(.zero, at: .fps24, base: .max80SubFrames)
        
        tc.set(
            .frames(Timecode.FrameCount(
                .frames((2073600 * 2) + 86400), // 2 days + 1 hour @ 24fps
                base: .max80SubFrames
            )),
            by: .allowingInvalid
        )

        #expect(tc.components == Timecode.Components(d: 2, h: 01))
    }
    
    @Test
    func static_componentsOfFrameCount_2997d() async {
        // edge cases
        
        let totalFramesIn24Hr = 2_589_408
        // let totalSubFramesIn24Hr = 207152640
        
        let tcc = Timecode.components(
            of: Timecode.FrameCount(
                .split(frames: totalFramesIn24Hr - 1, subFrames: 79),
                base: .max80SubFrames
            ),
            at: .fps29_97d
        )
        
        #expect(tcc == Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: 29, sf: 79))
    }
    
    @Test
    func isZero() async {
        // true
        
        // frames
        #expect(Timecode.FrameCount(.frames(0), base: .max80SubFrames).isZero)
        // split
        #expect(Timecode.FrameCount(.split(frames: 0, subFrames: 0), base: .max80SubFrames).isZero)
        // combined
        #expect(Timecode.FrameCount(.combined(frames: 0.0), base: .max80SubFrames).isZero)
        // split unitinterval
        #expect(Timecode.FrameCount(.splitUnitInterval(frames: 0, subFramesUnitInterval: 0.0), base: .max80SubFrames).isZero)
        
        // false
        
        // frames
        #expect(!Timecode.FrameCount(.frames(1), base: .max80SubFrames).isZero)
        #expect(!Timecode.FrameCount(.frames(-1), base: .max80SubFrames).isZero)
        // split
        #expect(!Timecode.FrameCount(.split(frames: 0, subFrames: 1), base: .max80SubFrames).isZero)
        #expect(!Timecode.FrameCount(.split(frames: 1, subFrames: 0), base: .max80SubFrames).isZero)
        #expect(!Timecode.FrameCount(.split(frames: 1, subFrames: 1), base: .max80SubFrames).isZero)
        #expect(!Timecode.FrameCount(.split(frames: 0, subFrames: -1), base: .max80SubFrames).isZero)
        #expect(!Timecode.FrameCount(.split(frames: -1, subFrames: 0), base: .max80SubFrames).isZero)
        #expect(!Timecode.FrameCount(.split(frames: -1, subFrames: -1), base: .max80SubFrames).isZero)
        // combined
        #expect(!Timecode.FrameCount(.combined(frames: 0.1), base: .max80SubFrames).isZero)
        #expect(!Timecode.FrameCount(.combined(frames: 1.0), base: .max80SubFrames).isZero)
        #expect(!Timecode.FrameCount(.combined(frames: -0.1), base: .max80SubFrames).isZero)
        #expect(!Timecode.FrameCount(.combined(frames: -1.0), base: .max80SubFrames).isZero)
        // split unitinterval
        #expect(!Timecode.FrameCount(.splitUnitInterval(frames: 0, subFramesUnitInterval: 0.1), base: .max80SubFrames).isZero)
        #expect(!Timecode.FrameCount(.splitUnitInterval(frames: 1, subFramesUnitInterval: 0.0), base: .max80SubFrames).isZero)
        #expect(!Timecode.FrameCount(.splitUnitInterval(frames: 1, subFramesUnitInterval: 0.1), base: .max80SubFrames).isZero)
        #expect(!Timecode.FrameCount(.splitUnitInterval(frames: 0, subFramesUnitInterval: -0.1), base: .max80SubFrames).isZero)
        #expect(!Timecode.FrameCount(.splitUnitInterval(frames: -1, subFramesUnitInterval: 0.0), base: .max80SubFrames).isZero)
        #expect(!Timecode.FrameCount(.splitUnitInterval(frames: -1, subFramesUnitInterval: -0.1), base: .max80SubFrames).isZero)
    }
    
    @Test
    func edgeCases() async throws {
        // test for really large values
        
        #expect(
            Timecode(
                .components(
                    d: 1234567891234564567,
                    h: 1234567891234564567,
                    m: 1234567891234564567,
                    s: 1234567891234564567,
                    f: 1234567891234564567,
                    sf: 1234567891234564567
                ),
                at: .fps24,
                base: .max100SubFrames,
                by: .allowingInvalid
            )
            .frameCount.wholeFrames
            == 0 // failsafe value
        )
    }
}
