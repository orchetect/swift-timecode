//
//  TimecodeInterval Rational Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import Testing

@Suite struct TimecodeInterval_Rational_Tests {
    @Test
    func rational() async throws {
        let ti = try TimecodeInterval(
            Fraction(60, 30),
            at: .fps24
        )
        
        #expect(ti.sign == .plus)
        
        #expect(try ti.absoluteInterval == Timecode(.components(s: 2), at: .fps24))
        
        #expect(try ti.flattened() == Timecode(.components(s: 2), at: .fps24))
        
        #expect(ti.rationalValue == Fraction(2, 1))
    }
    
    @Test
    func rationalNegative() async throws {
        let ti = try TimecodeInterval(
            Fraction(-60, 30),
            at: .fps24
        )
        
        #expect(ti.sign == .minus)
        
        #expect(try ti.absoluteInterval == Timecode(.components(s: 2), at: .fps24))
        
        // wraps around clock by underflowing
        #expect(try ti.flattened() == Timecode(.components(h: 23, m: 59, s: 58, f: 00), at: .fps24))
        
        #expect(ti.rationalValue == Fraction(-2, 1))
    }
    
    @Test
    func fraction_timecodeInterval() async throws {
        let ti = try Fraction(60, 30).timecodeInterval(at: .fps24)
        
        #expect(ti.sign == .plus)
        
        #expect(try ti.absoluteInterval == Timecode(.components(s: 2), at: .fps24))
    }
}
