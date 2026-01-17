//
//  Timecode Rational CMTime Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import CoreMedia
import SwiftTimecodeCore // do NOT import as @testable in this file
import Testing

@Suite struct Timecode_Source_Rational_CMTime_Tests {
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_init_CMTime_Exactly(frameRate: TimecodeFrameRate) async throws {
        let tc = try Timecode(
            .cmTime(CMTime(value: 10, timescale: 1)),
            at: frameRate,
            limit: .max24Hours
        )
        
        // don't imperatively check each result, just make sure that a value was set;
        // setter logic is unit-tested elsewhere, we just want to check the Timecode.init interface here.
        #expect(tc.seconds != 0)
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_init_CMTime(frameRate: TimecodeFrameRate) async throws {
        // these rational fractions and timecodes are taken from actual FCP XML files as known truth
        
        switch frameRate {
        case .fps23_976:
            #expect(
                try Timecode(.cmTime(CMTime(value: 335335, timescale: 24000)), at: frameRate).components
                == Timecode.Components(h: 00, m: 00, s: 13, f: 23)
            )
        case .fps24:
            #expect(
                try Timecode(.cmTime(CMTime(value: 167500, timescale: 12000)), at: frameRate).components
                == Timecode.Components(h: 00, m: 00, s: 13, f: 23)
            )
        case .fps24_98:
            break // TODO: finish this
        case .fps25: // same fraction is found in FCP XML for 25p and 25i video rates
            #expect(
                try Timecode(.cmTime(CMTime(value: 34900, timescale: 2500)), at: frameRate).components
                == Timecode.Components(h: 00, m: 00, s: 13, f: 24)
            )
        case .fps29_97: // same fraction is found in FCP XML for 29.97p and 29.97i video rates
            #expect(
                try Timecode(.cmTime(CMTime(value: 838838, timescale: 60000)), at: frameRate).components
                == Timecode.Components(h: 00, m: 00, s: 13, f: 29)
            )
            #expect(
                try Timecode(.cmTime(CMTime(value: 1920919, timescale: 30000)), at: frameRate).components
                == Timecode.Components(h: 00, m: 01, s: 03, f: 29)
            )
        case .fps29_97d:
            #expect(
                try Timecode(.cmTime(CMTime(value: 419419, timescale: 30000)), at: frameRate).components
                == Timecode.Components(h: 00, m: 00, s: 13, f: 29)
            )
            #expect(
                try Timecode(.cmTime(CMTime(value: 1918917, timescale: 30000)), at: frameRate).components
                == Timecode.Components(h: 00, m: 01, s: 03, f: 29)
            )
        case .fps30:
            #expect(
                try Timecode(.cmTime(CMTime(value: 83800, timescale: 6000)), at: frameRate).components
                == Timecode.Components(h: 00, m: 00, s: 13, f: 29)
            )
        case .fps30d:
            break // TODO: finish this
        case .fps47_952:
            break // TODO: finish this
        case .fps48:
            break // TODO: finish this
        case .fps50:
            #expect(
                try Timecode(.cmTime(CMTime(value: 69900, timescale: 5000)), at: frameRate).components
                == Timecode.Components(h: 00, m: 00, s: 13, f: 49)
            )
        case .fps59_94:
            #expect(
                try Timecode(.cmTime(CMTime(value: 839839, timescale: 60000)), at: frameRate).components
                == Timecode.Components(h: 00, m: 00, s: 13, f: 59)
            )
        case .fps59_94d:
            break // TODO: finish this
        case .fps60:
            #expect(
                try Timecode(.cmTime(CMTime(value: 83900, timescale: 6000)), at: frameRate).components
                == Timecode.Components(h: 00, m: 00, s: 13, f: 59)
            )
        case .fps60d:
            break // TODO: finish this
        case .fps90:
            #expect(
                try Timecode(.cmTime(CMTime(value: 90000, timescale: 9000)), at: frameRate).components
                == Timecode.Components(h: 00, m: 00, s: 10, f: 00)
            )
        case .fps95_904:
            break // TODO: finish this
        case .fps96:
            break // TODO: finish this
        case .fps100:
            break // TODO: finish this
        case .fps119_88:
            break // TODO: finish this
        case .fps119_88d:
            break // TODO: finish this
        case .fps120:
            break // TODO: finish this
        case .fps120d:
            break // TODO: finish this
        }
    }
    
    @Test
    func timecode_init_CMTime_Clamping() async {
        let tc = Timecode(
            .cmTime(CMTime(value: 86400 + 3600, timescale: 1)), // 25 hours @ 24fps
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
    func timecode_init_CMTime_Wrapping() async {
        let tc = Timecode(
            .cmTime(CMTime(value: 86400 + 3600, timescale: 1)), // 25 hours @ 24fps
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
    func timecode_init_CMTime_RawValues() async {
        let tc = Timecode(
            .cmTime(CMTime(value: (86400 * 2) + 3600, timescale: 1)), // 2 days + 1 hour @ 24fps
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
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_cmTimeValue(frameRate: TimecodeFrameRate) async throws {
        // test a small range of timecodes at each frame rate
        // and ensure the fraction can re-form the same timecode
        
        let start = try Timecode(.components(m: 8, f: 20), at: frameRate)
        let end = try Timecode(.components(m: 10, f: 5), at: frameRate)
        
        try (start ... end).forEach { tc in
            let f = tc.cmTimeValue
            let reformedTC = try Timecode(.cmTime(f), at: frameRate)
            #expect(tc == reformedTC)
        }
    }
    
    @Test
    func timecode_cmTimeValue_SpotCheck() async throws {
        let tc = try Timecode(.components(h: 00, m: 00, s: 13, f: 29), at: .fps29_97d)
        #expect(tc.cmTimeValue.value == 419419)
        #expect(tc.cmTimeValue.timescale == 30000)
    }
}
