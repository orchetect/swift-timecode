//
//  TimecodeInterval Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

@testable import SwiftTimecodeCore
import Testing

@Suite struct TimecodeInterval_Tests {
    @Test
    func initA() async throws {
        // positive
        
        let intervalTC = try Timecode(.components(m: 1), at: .fps24)
        
        let interval = TimecodeInterval(intervalTC)
        
        #expect(interval.absoluteInterval == intervalTC)
        #expect(interval.sign == .plus)
    }
    
    @Test
    func initB() async throws {
        // negative
        
        let intervalTC = try Timecode(.components(m: 1), at: .fps24)
        
        let interval = TimecodeInterval(intervalTC, .minus)
        
        #expect(interval.absoluteInterval == intervalTC)
        #expect(interval.sign == .minus)
    }
    
    @Test
    func initC() async {
        // Timecode.Components can contain negative values;
        // this should not alter the sign however
        
        let intervalTC = Timecode(.components(m: -1), at: .fps24, by: .allowingInvalid)
        
        let interval = TimecodeInterval(intervalTC)
        
        #expect(interval.absoluteInterval == intervalTC)
        #expect(interval.sign == .plus)
    }
    
    @Test
    func isNegative() async {
        #expect(
            !TimecodeInterval(Timecode(.zero, at: .fps24))
                .isNegative,
        )
        
        #expect(
            TimecodeInterval(Timecode(.zero, at: .fps24), .minus)
                .isNegative
        )
    }
    
    @Test
    func timecodeA() async throws {
        // positive
        
        let intervalTC = try Timecode(.components(m: 1), at: .fps24)
        
        let interval = TimecodeInterval(intervalTC)
        
        #expect(interval.flattened() == intervalTC)
    }
    
    @Test
    func timecodeB() async throws {
        // negative, wrapping
        
        let intervalTC = try Timecode(.components(m: 1), at: .fps24)
        
        let interval = TimecodeInterval(intervalTC, .minus)
        
        #expect(
            try interval.flattened()
                == Timecode(.components(h: 23, m: 59, s: 00, f: 00), at: .fps24)
        )
    }
    
    @Test
    func timecodeC() async throws {
        // positive, wrapping
        
        let intervalTC = Timecode(.components(h: 26), at: .fps24, by: .allowingInvalid)
        
        let interval = TimecodeInterval(intervalTC)
        
        #expect(
            try interval.flattened()
                == Timecode(.components(h: 02, m: 00, s: 00, f: 00), at: .fps24)
        )
    }
    
    /// Requires `@testable import`.
    @Test
    func timecodeOffsettingA() async throws {
        // positive
        
        let intervalTC = Timecode(.components(m: 1), at: .fps24, by: .allowingInvalid)
        
        let interval = TimecodeInterval(intervalTC)
        
        #expect(
            try interval.timecode(offsetting: Timecode(.components(h: 1), at: .fps24))
                == Timecode(.components(h: 01, m: 01, s: 00, f: 00), at: .fps24)
        )
    }
    
    /// Requires `@testable import`.
    @Test
    func timecodeOffsettingB() async throws {
        // negative
        
        let intervalTC = Timecode(.components(m: 1), at: .fps24, by: .allowingInvalid)
        
        let interval = TimecodeInterval(intervalTC, .minus)
        
        #expect(
            try interval.timecode(offsetting: Timecode(.components(h: 1), at: .fps24))
                == Timecode(.components(h: 00, m: 59, s: 00, f: 00), at: .fps24)
        )
    }
    
    @Test
    func realTimeValueA() async throws {
        // positive
        
        let intervalTC = try Timecode(.components(h: 1), at: .fps24)
        
        let interval = TimecodeInterval(intervalTC)
        
        #expect(interval.realTimeValue == intervalTC.realTimeValue)
    }
    
    @Test
    func realTimeValueB() async throws {
        // negative
        
        let intervalTC = try Timecode(.components(h: 1), at: .fps24)
        
        let interval = TimecodeInterval(intervalTC, .minus)
        
        #expect(interval.realTimeValue == -intervalTC.realTimeValue)
    }
    
    @Test
    func staticConstructors_Positive() async throws {
        let interval: TimecodeInterval = try .positive(
            Timecode(.components(h: 1), at: .fps24)
        )
        #expect(try interval.absoluteInterval == Timecode(.components(h: 1), at: .fps24))
        #expect(!interval.isNegative)
    }
    
    @Test
    func staticConstructors_Negative() async throws {
        let interval: TimecodeInterval = try .negative(
            Timecode(.components(h: 1), at: .fps24)
        )
        #expect(try interval.absoluteInterval == Timecode(.components(h: 1), at: .fps24))
        #expect(interval.isNegative)
    }
}
