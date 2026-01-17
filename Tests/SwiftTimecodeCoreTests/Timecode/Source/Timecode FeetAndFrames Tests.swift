//
//  Timecode FeetAndFrames Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore // do NOT import as @testable in this file
import Testing

@Suite struct Timecode_Source_FeetAndFrames_Tests {
    @Test
    func timecode_23_976fps_zero() throws {
        let ff = Timecode(.zero, at: .fps23_976).feetAndFramesValue
        #expect(ff.feet == 0)
        #expect(ff.frames == 0)
    }
    
    @Test
    func timecode_23_976fps_1min() throws {
        let ff = try Timecode(.components(m: 1), at: .fps23_976).feetAndFramesValue
        #expect(ff.feet == 90)
        #expect(ff.frames == 0)
    }
    
    @Test
    func timecode_24fps_zero() throws {
        let ff = Timecode(.zero, at: .fps24).feetAndFramesValue
        #expect(ff.feet == 0)
        #expect(ff.frames == 0)
    }
    
    @Test
    func timecode_24fps_1min() throws {
        let ff = try Timecode(.components(m: 1), at: .fps24).feetAndFramesValue
        #expect(ff.feet == 90)
        #expect(ff.frames == 0)
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_allRates_complex(frameRate: TimecodeFrameRate) throws {
        let ff = try Timecode(
            .components(h: 1, m: 2, s: 3, f: 4),
            at: frameRate
        )
        .feetAndFramesValue
        
        // TimecodeFrameRate.maxTotalFrames is a good reference for groupings
        // which shows frame rates with the same frame counts over time
        switch frameRate {
        case .fps23_976, .fps24:
            #expect(ff.feet == 5584)
            #expect(ff.frames == 12)
        case .fps24_98, .fps25:
            #expect(ff.feet == 5817)
            #expect(ff.frames == 07)
        case .fps29_97, .fps30:
            #expect(ff.feet == 6980)
            #expect(ff.frames == 14)
        case .fps29_97d, .fps30d:
            #expect(ff.feet == 6973)
            #expect(ff.frames == 14)
        case .fps47_952, .fps48:
            #expect(ff.feet == 11169)
            #expect(ff.frames == 04)
        case .fps50:
            #expect(ff.feet == 11634)
            #expect(ff.frames == 10)
        case .fps59_94, .fps60:
            #expect(ff.feet == 13961)
            #expect(ff.frames == 08)
        case .fps59_94d, .fps60d:
            #expect(ff.feet == 13947)
            #expect(ff.frames == 08)
        case .fps90:
            #expect(ff.feet == 20942)
            #expect(ff.frames == 02)
        case .fps95_904, .fps96:
            #expect(ff.feet == 22338)
            #expect(ff.frames == 04)
        case .fps100:
            #expect(ff.feet == 23269)
            #expect(ff.frames == 00)
        case .fps119_88, .fps120:
            #expect(ff.feet == 27922)
            #expect(ff.frames == 12)
        case .fps119_88d, .fps120d:
            #expect(ff.feet == 27894)
            #expect(ff.frames == 12)
        }
        
        #expect(ff.subFrames == 0)
    }
    
    /// Ensure subFrames are correct when set.
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_allRates_subFrames(frameRate: TimecodeFrameRate) throws {
        let ff = try Timecode(.components(h: 1, m: 2, s: 3, f: 4, sf: 24), at: frameRate)
            .feetAndFramesValue
        
        #expect(ff.subFrames == 24)
    }
    
    @Test
    func edgeCases() throws {
        // test for really large values
        
        #expect(throws: (any Error).self) { try FeetAndFrames("12345678912345645678+12345678912345645678") }
        #expect(throws: (any Error).self) { try FeetAndFrames("12345678912345645678+12345678912345645678.12345678912345645678") }
        #expect(throws: (any Error).self) { try FeetAndFrames("12345678912345645678+00") }
        #expect(throws: (any Error).self) { try FeetAndFrames("00+12345678912345645678") }
        #expect(throws: (any Error).self) { try FeetAndFrames("00+00.12345678912345645678") }
        
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
                by: .allowingInvalid
            )
            .feetAndFramesValue
            == FeetAndFrames(feet: 0, frames: 0, subFrames: 1234567891234564567) // failsafe values
        )
    }
}
