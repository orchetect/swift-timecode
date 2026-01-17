//
//  Timecode FrameCount Value Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore // do NOT import as @testable in this file
import Testing

@Suite struct Timecode_Source_FrameCount_Value_Tests {
    @Test
    func timecode_init_FrameCountValue_Exactly() async throws {
        let tc = try Timecode(
            .frames(670_907),
            at: .fps30,
            limit: .max24Hours
        )
        
        #expect(tc.days == 0)
        #expect(tc.hours == 6)
        #expect(tc.minutes == 12)
        #expect(tc.seconds == 43)
        #expect(tc.frames == 17)
        #expect(tc.subFrames == 0)
    }
    
    @Test
    func timecode_init_FrameCountValue_Clamping() async {
        let tc = Timecode(
            .frames(2073600 + 86400), // 25 hours @ 24fps
            at: .fps24,
            limit: .max24Hours,
            by: .clamping
        )
        
        #expect(
            tc.components
                == Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    @Test
    func timecode_init_FrameCountValue_Wrapping() async {
        let tc = Timecode(
            .frames(2073600 + 86400), // 25 hours @ 24fps
            at: .fps24,
            limit: .max24Hours,
            by: .wrapping
        )
        
        #expect(tc.days == 0)
        #expect(tc.hours == 1)
        #expect(tc.minutes == 0)
        #expect(tc.seconds == 0)
        #expect(tc.frames == 0)
        #expect(tc.subFrames == 0)
    }
    
    @Test
    func timecode_init_FrameCountValue_RawValues() async {
        let tc = Timecode(
            .frames((2073600 * 2) + 86400), // 2 days + 1 hour @ 24fps
            at: .fps24,
            limit: .max24Hours,
            by: .allowingInvalid
        )
        
        #expect(tc.days == 2)
        #expect(tc.hours == 1)
        #expect(tc.minutes == 0)
        #expect(tc.seconds == 0)
        #expect(tc.frames == 0)
        #expect(tc.subFrames == 0)
    }
}
