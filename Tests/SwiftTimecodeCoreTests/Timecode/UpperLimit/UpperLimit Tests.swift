//
//  UpperLimit Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2026 Steffan Andrews • Licensed under MIT License
//

@testable import SwiftTimecodeCore
import Testing

@Suite
struct Timecode_UpperLimit {
    @Test
    func limit24Hours() {
        let upperLimit: Timecode.UpperLimit = .max24Hours

        #expect(upperLimit.maxDays == 1)
        #expect(upperLimit.maxDaysExpressible == 0)

        #expect(upperLimit.maxHours == 24)
        #expect(upperLimit.maxHoursExpressible == 23)
        #expect(upperLimit.maxHoursTotal == 23)
    }

    @Test
    func limit100Days() {
        let upperLimit: Timecode.UpperLimit = .max100Days

        #expect(upperLimit.maxDays == 100)
        #expect(upperLimit.maxDaysExpressible == 99)

        #expect(upperLimit.maxHours == 24)
        #expect(upperLimit.maxHoursExpressible == 23)
        #expect(upperLimit.maxHoursTotal == (24 * 100) - 1)
    }
}
