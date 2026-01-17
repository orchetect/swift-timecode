//
//  Timecode Operators Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore // do NOT import as @testable in this file
import Testing

@Suite struct Timecode_Operators_Tests {
    @Test
    func add_and_Subtract_Operators() async throws {
        var tc = Timecode(.zero, at: .fps30)
        
        // + and - operators
        
        tc = try Timecode(.components(h: 00, m: 00, s: 00, f: 00), at: .fps30)
        
        tc = try tc + Timecode(.components(h: 00, m: 00, s: 00, f: 05), at: .fps30)
        #expect(tc.components == Timecode.Components(h: 00, m: 00, s: 00, f: 05))
        
        tc = try tc - Timecode(.components(h: 00, m: 00, s: 00, f: 04), at: .fps30)
        #expect(tc.components == Timecode.Components(h: 00, m: 00, s: 00, f: 01))
        
        // (underflow: wraps)
        tc = try tc - Timecode(.components(h: 00, m: 00, s: 00, f: 04), at: .fps30)
        #expect(tc.components == Timecode.Components(h: 23, m: 59, s: 59, f: 27))
        
        // (overflow: wraps)
        tc = try tc + Timecode(.components(h: 00, m: 00, s: 00, f: 05), at: .fps30)
        #expect(tc.components == Timecode.Components(h: 00, m: 00, s: 00, f: 02))
        
        // += and -= operators
        
        tc = try Timecode(.components(h: 00, m: 00, s: 00, f: 00), at: .fps30)
        
        tc += try Timecode(.components(h: 00, m: 00, s: 00, f: 05), at: .fps30)
        #expect(tc.components == Timecode.Components(h: 00, m: 00, s: 00, f: 05))
        
        tc -= try Timecode(.components(h: 00, m: 00, s: 00, f: 04), at: .fps30)
        #expect(tc.components == Timecode.Components(h: 00, m: 00, s: 00, f: 01))
        
        // (underflow: wraps)
        tc -= try Timecode(.components(h: 00, m: 00, s: 00, f: 04), at: .fps30)
        #expect(tc.components == Timecode.Components(h: 23, m: 59, s: 59, f: 27))
        
        // (overflow: wraps)
        tc += try Timecode(.components(h: 00, m: 00, s: 00, f: 05), at: .fps30)
        #expect(tc.components == Timecode.Components(h: 00, m: 00, s: 00, f: 02))
    }
    
    @Test
    func add_Operator_DifferingFrameRates() async throws {
        let tc1 = try Timecode(.components(h: 1), at: .fps25)
        let tc2 = try Timecode(.components(h: 1), at: .fps29_97) // 1:00:03:15 @ 25fps
        
        let result = tc1 + tc2
        
        #expect(try result == Timecode(.components(h: 02, m: 00, s: 03, f: 15), at: .fps25))
    }
    
    @Test
    func addAssign_Operator_DifferingFrameRates() async throws {
        var tc1 = try Timecode(.components(h: 1), at: .fps25)
        let tc2 = try Timecode(.components(h: 1), at: .fps29_97) // 1:00:03:15 @ 25fps
        
        tc1 += tc2
        
        #expect(try tc1 == Timecode(.components(h: 02, m: 00, s: 03, f: 15), at: .fps25))
    }
    
    @Test
    func subtract_Operator_DifferingFrameRates() async throws {
        let tc1 = try Timecode(.components(h: 2), at: .fps25)
        let tc2 = try Timecode(.components(h: 1), at: .fps29_97) // 1:00:03:15 @ 25fps
        
        let result = tc1 - tc2
        
        #expect(try result == Timecode(.components(h: 00, m: 59, s: 56, f: 10), at: .fps25))
    }
    
    @Test
    func subtractAssign_Operator_DifferingFrameRates() async throws {
        var tc1 = try Timecode(.components(h: 2), at: .fps25)
        let tc2 = try Timecode(.components(h: 1), at: .fps29_97) // 1:00:03:15 @ 25fps
        
        tc1 -= tc2
        
        #expect(try tc1 == Timecode(.components(h: 00, m: 59, s: 56, f: 10), at: .fps25))
    }
    
    @Test
    func multiply_and_Divide_Double_Operators() async throws {
        var tc = Timecode(.zero, at: .fps30)
        
        // * and / operators
        
        tc = try Timecode(.components(h: 01, m: 00, s: 00, f: 00), at: .fps30)
        
        tc = tc * 5
        #expect(tc.components == Timecode.Components(h: 05, m: 00, s: 00, f: 00))
        
        tc = tc / 5
        #expect(tc.components == Timecode.Components(h: 01, m: 00, s: 00, f: 00))
        
        // (overflow: wraps)
        tc = tc * 30 // == aka 30:00:00:00, 6 hours over 24:00:00:00
        #expect(tc.components == Timecode.Components(h: 06, m: 00, s: 00, f: 00))
        
        // (underflow: wraps)
        tc = tc * -2.5 // == aka -15:00:00:00, 15 hours under 24:00:00:00
        #expect(tc.components == Timecode.Components(h: 09, m: 00, s: 00, f: 00))
        
        // (underflow: wraps)
        tc = tc / -2 // == aka -4:30:00:00, 4 hours 30 min under 24:00:00:00
        #expect(tc.components == Timecode.Components(h: 19, m: 30, s: 00, f: 00))
        
        // *= and /= operators
        
        tc = try Timecode(.components(h: 01, m: 00, s: 00, f: 00), at: .fps30)
        
        tc *= 5
        #expect(tc.components == Timecode.Components(h: 05, m: 00, s: 00, f: 00))
        
        tc /= 5
        #expect(tc.components == Timecode.Components(h: 01, m: 00, s: 00, f: 00))
        
        // (overflow: wraps)
        tc *= 30 // == aka 30:00:00:00, 6 hours over 24:00:00:00
        #expect(tc.components == Timecode.Components(h: 06, m: 00, s: 00, f: 00))
        
        // (underflow: wraps)
        tc *= -2.5 // == aka -15:00:00:00, 15 hours under 24:00:00:00
        #expect(tc.components == Timecode.Components(h: 09, m: 00, s: 00, f: 00))
        
        // (underflow: wraps)
        tc /= -2 // == aka -4:30:00:00, 4 hours 30 min under 24:00:00:00
        #expect(tc.components == Timecode.Components(h: 19, m: 30, s: 00, f: 00))
    }
    
    @Test
    func divide_Timecode_Operator() async throws {
        // / operator
        
        #expect(
            try Timecode(.components(h: 01, m: 00, s: 00, f: 00), at: .fps30) /
                Timecode(.components(h: 01, m: 00, s: 00, f: 00), at: .fps30)
            == 1.0
        )
        
        #expect(
            try Timecode(.components(h: 01, m: 00, s: 00, f: 00), at: .fps30) /
                Timecode(.components(h: 00, m: 10, s: 00, f: 00), at: .fps30)
            == 6.0
        )
        
        #expect(
            try Timecode(.components(h: 01, m: 00, s: 00, f: 00), at: .fps30) /
                Timecode(.components(h: 00, m: 16, s: 00, f: 00), at: .fps30)
            == 3.75
        )
    }
    
    @Test
    func divide_Timecode_Operator_DifferingFrameRates() async throws {
        // / operator
        
        #expect(
            try Timecode(.components(h: 01, m: 00, s: 00, f: 00), at: .fps30) /
                Timecode(.components(h: 01, m: 00, s: 00, f: 00), at: .fps29_97) // longer real time than 30fps
            == 30 / (30 * 1.001)
        )
    }
}
