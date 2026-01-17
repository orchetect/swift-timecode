//
//  Hashable Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore // do NOT import as @testable in this file
import Testing

@Suite struct Timecode_Hashable_Tests {
    @Test
    func hashValue() throws {
        // hashValues should be equal
        
        #expect(
            try Timecode(.string("01:00:00:00"), at: .fps23_976).hashValue
                == Timecode(.string("01:00:00:00"), at: .fps23_976).hashValue
        )
        #expect(
            try Timecode(.string("01:00:00:01"), at: .fps23_976).hashValue
                != Timecode(.string("01:00:00:00"), at: .fps23_976).hashValue
        )
        
        #expect(
            try Timecode(.string("01:00:00:00"), at: .fps23_976).hashValue
                != Timecode(.string("01:00:00:00"), at: .fps24).hashValue
        )
        #expect(
            try Timecode(.string("01:00:00:00"), at: .fps23_976).hashValue
                != Timecode(.string("01:00:00:00"), at: .fps29_97).hashValue
        )
    }
    
    @Test
    func hashable_dictionary() throws {
        // Dictionary / Set
        
        var dict: [Timecode: String] = [:]
        try dict[Timecode(.string("01:00:00:00"), at: .fps23_976)] = "A Spot Note Here"
        try dict[Timecode(.string("01:00:00:06"), at: .fps23_976)] = "A Spot Note Also Here"
        #expect(dict.count == 2)
        try dict[Timecode(.string("01:00:00:00"), at: .fps24)] = "This should not replace"
        #expect(dict.count == 3)
        
        #expect(try dict[Timecode(.string("01:00:00:00"), at: .fps23_976)] == "A Spot Note Here")
        #expect(try dict[Timecode(.string("01:00:00:00"), at: .fps24)] == "This should not replace")
    }
    
    @Test
    func hashable_set() throws {
        // timecode is hashed on component values and properties
        
        let timecodes = try TimecodeFrameRate.allCases.map { frameRate in
            try Timecode(.string("01:00:00:00"), at: frameRate)
        }
        
        let timecodesSet = Set(timecodes)
        
        #expect(timecodesSet.count == timecodes.count)
    }
}
