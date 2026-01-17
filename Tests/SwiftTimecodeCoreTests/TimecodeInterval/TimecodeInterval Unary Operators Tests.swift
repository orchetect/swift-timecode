//
//  TimecodeInterval Unary Operators Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import Testing

@Suite struct TimecodeInterval_UnaryOperators_Tests {
    @Test
    func negative() async throws {
        let interval = try -Timecode(.components(m: 1), at: .fps24)
        
        #expect(try interval.absoluteInterval == Timecode(.components(m: 1), at: .fps24))
        #expect(interval.isNegative)
    }
    
    @Test
    func positive() async throws {
        let interval = try +Timecode(.components(m: 1), at: .fps24)
        
        #expect(try interval.absoluteInterval == Timecode(.components(m: 1), at: .fps24))
        #expect(!interval.isNegative)
    }
}
