//
//  TimecodeFrameRate Sorted Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import Testing

@Suite struct TimecodeFrameRate_Sorted_Tests {
    @Test
    func sortOrder() async {
        let unsorted: [TimecodeFrameRate] = [
            .fps29_97,
            .fps30,
            .fps24,
            .fps120
        ]
        
        let correctOrder: [TimecodeFrameRate] = [
            .fps24,
            .fps29_97,
            .fps30,
            .fps120
        ]
        
        let sorted = unsorted.sorted()
        
        #expect(unsorted != sorted)
        
        #expect(sorted == correctOrder)
    }
}
