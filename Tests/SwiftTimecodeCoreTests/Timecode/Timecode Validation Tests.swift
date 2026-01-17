//
//  Timecode Validation Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import Testing

@Suite struct Timecode_Validation_Tests {
    @Test
    func validWithinRanges() async {
        // typical valid values
        
        let fr = TimecodeFrameRate.fps24
        let limit = Timecode.UpperLimit.max24Hours
        
        let tc = Timecode(.zero, at: fr, base: .max80SubFrames, limit: limit)
        
        #expect(tc.invalidComponents == [])
        #expect(tc.components.invalidComponents(at: fr, base: .max80SubFrames, limit: limit) == [])
        
        #expect(tc.validRange(of: .days) == 0 ... 0)
        #expect(tc.validRange(of: .hours) == 0 ... 23)
        #expect(tc.validRange(of: .minutes) == 0 ... 59)
        #expect(tc.validRange(of: .seconds) == 0 ... 59)
        #expect(tc.validRange(of: .frames) == 0 ... 23)
        #expect(tc.validRange(of: .subFrames) == 0 ... 79)
    }
    
    @Test
    func invalidOverRanges() async {
        // invalid - over ranges
        
        let fr = TimecodeFrameRate.fps24
        let limit = Timecode.UpperLimit.max24Hours
        
        var tc = Timecode(.zero, at: fr, limit: limit)
        tc.days = 5
        tc.hours = 25
        tc.minutes = 75
        tc.seconds = 75
        tc.frames = 52
        tc.subFrames = 500
        
        #expect(
            tc.invalidComponents
            == [.days, .hours, .minutes, .seconds, .frames, .subFrames]
        )
        #expect(
            tc.components.invalidComponents(at: fr, base: .max80SubFrames, limit: limit)
            == [.days, .hours, .minutes, .seconds, .frames, .subFrames]
        )
    }
    
    @Test
    func testInvalidUnderRanges() async {
        // invalid - under ranges
        
        let fr = TimecodeFrameRate.fps24
        let limit = Timecode.UpperLimit.max24Hours
        
        var tc = Timecode(.zero, at: fr, limit: limit)
        tc.days = -1
        tc.hours = -1
        tc.minutes = -1
        tc.seconds = -1
        tc.frames = -1
        tc.subFrames = -1
        
        #expect(
            tc.invalidComponents
            == [.days, .hours, .minutes, .seconds, .frames, .subFrames]
        )
        #expect(
            tc.components.invalidComponents(at: fr, base: .max80SubFrames, limit: limit)
            == [.days, .hours, .minutes, .seconds, .frames, .subFrames]
        )
    }
    
    /// Test each subframes base range.
    @Test(arguments: Timecode.SubFramesBase.allCases)
    func subFrames(base: Timecode.SubFramesBase) async {
        let fr = TimecodeFrameRate.fps24
        let limit = Timecode.UpperLimit.max24Hours
        let tc = Timecode(.zero, at: fr, base: base, limit: limit)
        
        let range: ClosedRange<Int> = switch base {
        case .quarterFrames: 0 ... 3
        case .max80SubFrames: 0 ... 79
        case .max100SubFrames: 0 ... 99
        }
        
        #expect(tc.validRange(of: .subFrames) == range)
    }
    
    /// Perform a spot-check to ensure drop rate timecode validation works as expected.
    @Test(arguments: TimecodeFrameRate.allDrop)
    func dropFrame(frameRate: TimecodeFrameRate) async {
        let limit = Timecode.UpperLimit.max24Hours
            
        // every 10 minutes, no frames are skipped
            
        do {
            var tc = Timecode(.zero, at: frameRate, limit: limit)
            tc.minutes = 0
            tc.frames = 0
                
            #expect(tc.invalidComponents == [])
            #expect(
                tc.components.invalidComponents(
                    at: frameRate,
                    base: .max80SubFrames,
                    limit: limit
                )
                == []
            )
        }
            
        // all other minutes each skip frame 0 and 1
            
        for minute in 1 ... 9 {
            var tc = Timecode(.zero, at: frameRate, limit: limit)
            tc.minutes = minute
            tc.frames = 0
                
            #expect(
                tc.invalidComponents == [.frames],
                "for \(frameRate) at \(minute) minutes"
            )
            #expect(
                tc.components.invalidComponents(
                    at: frameRate,
                    base: .max80SubFrames,
                    limit: limit
                )
                == [.frames],
                "for \(frameRate) at \(minute) minutes"
            )
                
            tc = Timecode(.zero, at: frameRate, limit: limit)
            tc.minutes = minute
            tc.frames = 1
                
            #expect(
                tc.invalidComponents == [.frames],
                "for \(frameRate) at \(minute) minutes"
            )
            #expect(
                tc.components.invalidComponents(
                    at: frameRate,
                    base: .max80SubFrames,
                    limit: limit
                )
                == [.frames],
                "for \(frameRate) at \(minute) minutes"
            )
        }
    }
    
    @Test
    func dropFrameEdgeCases() async throws {
        let comps = Timecode.Components(h: 23, m: 59, s: 59, f: 29, sf: 79)
        
        let tc = try Timecode(
            .components(comps),
            at: .fps29_97d,
            base: .max80SubFrames,
            limit: .max24Hours
        )
        
        #expect(tc.components == comps)
        #expect(tc.invalidComponents == [])
    }
    
    @Test
    func maxFrames() async {
        let subFramesBase: Timecode.SubFramesBase = .max80SubFrames
        
        let tc = Timecode(
            .zero,
            at: .fps24,
            base: subFramesBase,
            limit: .max24Hours
        )
        
        #expect(tc.validRange(of: .subFrames) == 0 ... (subFramesBase.rawValue - 1))
        #expect(tc.subFrames == 0)
        #expect(tc.subFramesBase == subFramesBase)
        
        let mf = tc.maxFrameCountExpressible
        #expect(mf.doubleValue == 2_073_599.9875)
        
        let tcc = Timecode.components(of: mf, at: tc.frameRate)
        #expect(tcc == Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: 23, sf: subFramesBase.rawValue - 1))
    }
}
