//
//  TimecodeInterval Real Time Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import Testing

@Suite
struct TimecodeInterval_RealTime_Tests {
    @Test
    func realTime() throws {
        let ti = try TimecodeInterval(
            realTime: 2.0,
            at: .fps24
        )

        #expect(ti.sign == .plus)

        #expect(try ti.absoluteInterval == Timecode(.components(s: 2), at: .fps24))

        #expect(try ti.flattened() == Timecode(.components(s: 2), at: .fps24))

        #expect(ti.rationalValue == Fraction(2, 1))
    }

    @Test
    func realTimeNegative() throws {
        let ti = try TimecodeInterval(
            realTime: -2.0,
            at: .fps24
        )

        #expect(ti.sign == .minus)

        #expect(try ti.absoluteInterval == Timecode(.components(s: 2), at: .fps24))

        // wraps around clock by underflowing
        #expect(try ti.flattened() == Timecode(.components(h: 23, m: 59, s: 58, f: 00), at: .fps24))

        #expect(ti.rationalValue == Fraction(-2, 1))
    }

    @Test
    func timeInterval_timecodeInterval() throws {
        let ti = try 2.0.timecodeInterval(at: .fps24)

        #expect(ti.sign == .plus)

        #expect(try ti.absoluteInterval == Timecode(.components(s: 2), at: .fps24))
    }
}
