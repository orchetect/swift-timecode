//
//  TimecodeInterval Rational CMTime Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(CoreMedia)

import CoreMedia
import SwiftTimecodeCore
import Testing

@Suite
struct TimecodeInterval_Rational_CMTime_Tests {
    @Test
    func timecodeInterval_init_cmTime() throws {
        let ti = try TimecodeInterval(
            CMTime(value: 60, timescale: 30),
            at: .fps24
        )

        #expect(ti.sign == .plus)

        #expect(try ti.absoluteInterval == Timecode(.components(s: 2), at: .fps24))
    }

    @Test
    func cmTime() throws {
        let ti = try TimecodeInterval(
            Timecode(.components(s: 2), at: .fps24)
        )

        let cmTime = ti.cmTimeValue

        #expect(cmTime.seconds.sign == .plus)
        #expect(cmTime.value == 2)
        #expect(cmTime.timescale == 1)
    }

    @Test
    func cmTime_timecodeInterval() throws {
        let ti = try CMTime(value: 60, timescale: 30).timecodeInterval(at: .fps24)

        #expect(ti.sign == .plus)

        #expect(try ti.absoluteInterval == Timecode(.components(s: 2), at: .fps24))
    }
}

#endif
