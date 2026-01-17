//
//  Comparable Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore // do NOT import as @testable in this file
import Testing

@Suite struct Timecode_Comparable_Tests {
    /// ==
    @Test
    func timecode_Equatable() async throws {
        #expect(
            try Timecode(.string("01:00:00:00"), at: .fps23_976)
            == Timecode(.string("01:00:00:00"), at: .fps23_976)
        )
        // frame rate should always be the same, even if elapsed real time is equal
        #expect(
            try Timecode(.string("01:00:00:00"), at: .fps23_976)
            != Timecode(.string("01:00:00:00"), at: .fps29_97)
        )
        
        // == where elapsed frame count matches but frame rate differs (two frame rates where elapsed frames in 24 hours is identical)
        
        #expect(
            try Timecode(.string("01:00:00:00"), at: .fps23_976)
            != Timecode(.string("01:00:00:00"), at: .fps24)
        )
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Equatable(frameRate: TimecodeFrameRate) async throws {
        #expect(
            try Timecode(.string("01:00:00:00"), at: frameRate)
                == Timecode(.string("01:00:00:00"), at: frameRate)
        )
        
        #expect(
            try Timecode(.string("01:00:00:01"), at: frameRate)
                == Timecode(.string("01:00:00:01"), at: frameRate)
        )
    }
    
    /// < >
    @Test
    func timecode_Comparable() async throws {
        #expect(!(
            try Timecode(.string("01:00:00:00"), at: .fps23_976) // false because they're ==
            < Timecode(.string("01:00:00:00"), at: .fps29_97)
        ))
        #expect(!(
            try Timecode(.string("01:00:00:00"), at: .fps23_976) // false because they're ==
            > Timecode(.string("01:00:00:00"), at: .fps29_97)
        ))
        
        #expect(!(
            try Timecode(.string("01:00:00:00"), at: .fps23_976) // false because they're ==
            < Timecode(.string("01:00:00:00"), at: .fps23_976)
        ))
        #expect(!(
            try Timecode(.string("01:00:00:00"), at: .fps23_976) // false because they're ==
            > Timecode(.string("01:00:00:00"), at: .fps23_976)
        ))
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Comparable(frameRate: TimecodeFrameRate) async throws {
        #expect(
            try Timecode(.string("01:00:00:00"), at: frameRate)
                < Timecode(.string("01:00:00:01"), at: frameRate)
        )
        
        #expect(
            try Timecode(.string("01:00:00:01"), at: frameRate)
                > Timecode(.string("01:00:00:00"), at: frameRate)
        )
    }
    
    /// Assumes timeline start of zero (00:00:00:00)
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Comparable_Sorted(frameRate: TimecodeFrameRate) async throws {
        let presortedTimecodes: [Timecode] = try [
            Timecode(.string("00:00:00:00"), at: frameRate),
            Timecode(.string("00:00:00:01"), at: frameRate),
            Timecode(.string("00:00:00:14"), at: frameRate),
            Timecode(.string("00:00:00:15"), at: frameRate),
            Timecode(.string("00:00:00:15"), at: frameRate), // sequential dupe
            Timecode(.string("00:00:01:00"), at: frameRate),
            Timecode(.string("00:00:01:01"), at: frameRate),
            Timecode(.string("00:00:01:23"), at: frameRate),
            Timecode(.string("00:00:02:00"), at: frameRate),
            Timecode(.string("00:01:00:05"), at: frameRate),
            Timecode(.string("00:02:00:08"), at: frameRate),
            Timecode(.string("00:23:00:10"), at: frameRate),
            Timecode(.string("01:00:00:00"), at: frameRate),
            Timecode(.string("02:00:00:00"), at: frameRate),
            Timecode(.string("03:00:00:00"), at: frameRate)
        ]
        
        // shuffle
        var shuffledTimecodes = presortedTimecodes
        shuffledTimecodes.guaranteedShuffle()
        
        // sort the shuffled array
        let resortedTimecodes = shuffledTimecodes.sorted()
        
        #expect(resortedTimecodes == presortedTimecodes, "\(frameRate)fps")
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Sorted_1HourStart(frameRate: TimecodeFrameRate) async throws {
        let presorted: [Timecode] = try [
            Timecode(.string("01:00:00:00"), at: frameRate),
            Timecode(.string("02:00:00:00"), at: frameRate),
            Timecode(.string("03:00:00:00"), at: frameRate),
            Timecode(.string("00:00:00:00"), at: frameRate),
            Timecode(.string("00:00:00:01"), at: frameRate),
            Timecode(.string("00:00:00:14"), at: frameRate),
            Timecode(.string("00:00:00:15"), at: frameRate),
            Timecode(.string("00:00:00:15"), at: frameRate), // sequential dupe
            Timecode(.string("00:00:01:00"), at: frameRate),
            Timecode(.string("00:00:01:01"), at: frameRate),
            Timecode(.string("00:00:01:23"), at: frameRate),
            Timecode(.string("00:00:02:00"), at: frameRate),
            Timecode(.string("00:01:00:05"), at: frameRate),
            Timecode(.string("00:02:00:08"), at: frameRate),
            Timecode(.string("00:23:00:10"), at: frameRate)
        ]
        
        // shuffle
        var shuffled = presorted
        shuffled.guaranteedShuffle()
        
        // sort the shuffled array ascending
        let sortedAscending = try shuffled.sorted(
            ascending: true,
            timelineStart: Timecode(.string("01:00:00:00"), at: frameRate)
        )
        #expect(sortedAscending == presorted, "\(frameRate)fps")
        
        // sort the shuffled array descending
        let sortedDecending = try shuffled.sorted(
            ascending: false,
            timelineStart: Timecode(.string("01:00:00:00"), at: frameRate)
        )
        let presortedReversed = Array(presorted.reversed())
        #expect(sortedDecending == presortedReversed, "\(frameRate)fps")
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Sort_1HourStart(frameRate: TimecodeFrameRate) async throws {
        let presorted: [Timecode] = try [
            Timecode(.string("01:00:00:00"), at: frameRate),
            Timecode(.string("02:00:00:00"), at: frameRate),
            Timecode(.string("03:00:00:00"), at: frameRate),
            Timecode(.string("00:00:00:00"), at: frameRate),
            Timecode(.string("00:00:00:01"), at: frameRate),
            Timecode(.string("00:00:00:14"), at: frameRate),
            Timecode(.string("00:00:00:15"), at: frameRate),
            Timecode(.string("00:00:00:15"), at: frameRate), // sequential dupe
            Timecode(.string("00:00:01:00"), at: frameRate),
            Timecode(.string("00:00:01:01"), at: frameRate),
            Timecode(.string("00:00:01:23"), at: frameRate),
            Timecode(.string("00:00:02:00"), at: frameRate),
            Timecode(.string("00:01:00:05"), at: frameRate),
            Timecode(.string("00:02:00:08"), at: frameRate),
            Timecode(.string("00:23:00:10"), at: frameRate)
        ]
        
        // shuffle
        var shuffled = presorted
        shuffled.guaranteedShuffle()
        
        // sort the shuffled array ascending
        var sortedAscending = shuffled
        try sortedAscending.sort(
            ascending: true,
            timelineStart: Timecode(.string("01:00:00:00"), at: frameRate)
        )
        #expect(sortedAscending == presorted, "\(frameRate)fps")
        
        // sort the shuffled array descending
        var sortedDecending = shuffled
        try sortedDecending.sort(
            ascending: false,
            timelineStart: Timecode(.string("01:00:00:00"), at: frameRate)
        )
        let presortedReversed = Array(presorted.reversed())
        #expect(sortedDecending == presortedReversed, "\(frameRate)fps")
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Sorted_TimecodeSortComparator_1HourStart(frameRate: TimecodeFrameRate) async throws {
        let presorted: [Timecode] = try [
            Timecode(.string("01:00:00:00"), at: frameRate),
            Timecode(.string("02:00:00:00"), at: frameRate),
            Timecode(.string("03:00:00:00"), at: frameRate),
            Timecode(.string("00:00:00:00"), at: frameRate),
            Timecode(.string("00:00:00:01"), at: frameRate),
            Timecode(.string("00:00:00:14"), at: frameRate),
            Timecode(.string("00:00:00:15"), at: frameRate),
            Timecode(.string("00:00:00:15"), at: frameRate), // sequential dupe
            Timecode(.string("00:00:01:00"), at: frameRate),
            Timecode(.string("00:00:01:01"), at: frameRate),
            Timecode(.string("00:00:01:23"), at: frameRate),
            Timecode(.string("00:00:02:00"), at: frameRate),
            Timecode(.string("00:01:00:05"), at: frameRate),
            Timecode(.string("00:02:00:08"), at: frameRate),
            Timecode(.string("00:23:00:10"), at: frameRate)
        ]
        
        // shuffle
        var shuffled = presorted
        shuffled.guaranteedShuffle()
        
        // sort the shuffled array ascending
        let ascendingComparator = try TimecodeSortComparator(
            order: .forward,
            timelineStart: Timecode(.string("01:00:00:00"), at: frameRate)
        )
        let sortedAscending = shuffled
            .sorted(using: ascendingComparator)
        #expect(sortedAscending == presorted, "\(frameRate)fps")
        
        // sort the shuffled array descending
        let descendingComparator = try TimecodeSortComparator(
            order: .reverse,
            timelineStart: Timecode(.string("01:00:00:00"), at: frameRate)
        )
        let sortedDecending = shuffled
            .sorted(using: descendingComparator)
        let presortedReversed = Array(presorted.reversed())
        #expect(sortedDecending == presortedReversed, "\(frameRate)fps")
    }
    
    /// For comparison with the context of a timeline that is != `00:00:00:00`
    @Test
    func compareTo() async throws {
        let frameRate: TimecodeFrameRate = .fps24

        func tc(_ string: String) throws -> Timecode {
            try Timecode(.string(string), at: frameRate)
        }

        // orderedSame (==)

        #expect(
            try tc("00:00:00:00").compare(to: tc("00:00:00:00"), timelineStart: tc("00:00:00:00"))
                == .orderedSame
        )

        #expect(
            try tc("00:00:00:00").compare(to: tc("00:00:00:00"), timelineStart: tc("01:00:00:00"))
                == .orderedSame
        )

        #expect(
            try tc("00:00:00:00.01").compare(to: tc("00:00:00:00.01"), timelineStart: tc("00:00:00:00"))
                == .orderedSame
        )

        #expect(
            try tc("01:00:00:00").compare(to: tc("01:00:00:00"), timelineStart: tc("00:00:00:00"))
                == .orderedSame
        )

        #expect(
            try tc("01:00:00:00").compare(to: tc("01:00:00:00"), timelineStart: tc("01:00:00:00"))
                == .orderedSame
        )

        #expect(
            try tc("01:00:00:00").compare(to: tc("01:00:00:00"), timelineStart: tc("02:00:00:00"))
                == .orderedSame
        )

        // orderedAscending (<)

        #expect(
            try tc("00:00:00:00").compare(to: tc("00:00:00:00.01"), timelineStart: tc("00:00:00:00"))
                == .orderedAscending
        )

        #expect(
            try tc("00:00:00:00").compare(to: tc("00:00:00:01"), timelineStart: tc("00:00:00:00"))
                == .orderedAscending
        )

        #expect(
            try tc("00:00:00:00").compare(to: tc("00:00:00:01"), timelineStart: tc("01:00:00:00"))
                == .orderedAscending
        )

        #expect(
            try tc("23:00:00:00").compare(to: tc("00:00:00:00"), timelineStart: tc("23:00:00:00"))
                == .orderedAscending
        )

        #expect(
            try tc("23:30:00:00").compare(to: tc("00:00:00:00"), timelineStart: tc("23:00:00:00"))
                == .orderedAscending
        )

        #expect(
            try tc("23:30:00:00").compare(to: tc("01:00:00:00"), timelineStart: tc("23:00:00:00"))
                == .orderedAscending
        )

        // orderedDescending (>)

        #expect(
            try tc("00:00:00:00.01").compare(to: tc("00:00:00:00"), timelineStart: tc("00:00:00:00"))
                == .orderedDescending
        )

        #expect(
            try tc("00:00:00:01").compare(to: tc("00:00:00:00"), timelineStart: tc("00:00:00:00"))
                == .orderedDescending
        )

        #expect(
            try tc("23:30:00:00").compare(to: tc("00:00:00:00"), timelineStart: tc("00:00:00:00"))
                == .orderedDescending
        )

        #expect(
            try tc("00:00:00:00").compare(to: tc("23:30:00:00"), timelineStart: tc("23:00:00:00"))
                == .orderedDescending
        )
    }
    
    @Test
    func collection_isSorted() async throws {
        let frameRate: TimecodeFrameRate = .fps24
        
        func tc(_ string: String) throws -> Timecode {
            try Timecode(.string(string), at: frameRate)
        }
        
        #expect(
            try [
                tc("00:00:00:00"),
                tc("00:00:00:01"),
                tc("00:00:00:14"),
                tc("00:00:00:15"),
                tc("00:00:00:15"), // sequential dupe
                tc("00:00:01:00"),
                tc("00:00:01:01"),
                tc("00:00:01:23"),
                tc("00:00:02:00"),
                tc("00:01:00:05"),
                tc("00:02:00:08"),
                tc("00:23:00:10"),
                tc("01:00:00:00"),
                tc("02:00:00:00"),
                tc("03:00:00:00")
            ]
                .isSorted() // timelineStart of zero
        )
        
        #expect(!(
            try [
                tc("00:00:00:00"),
                tc("00:00:00:01"),
                tc("00:00:00:14"),
                tc("00:00:00:15"),
                tc("00:00:00:15"), // sequential dupe
                tc("00:00:01:00"),
                tc("00:00:01:01"),
                tc("00:00:01:23"),
                tc("00:00:02:00"),
                tc("00:01:00:05"),
                tc("00:02:00:08"),
                tc("00:23:00:10"),
                tc("01:00:00:00"),
                tc("02:00:00:00"),
                tc("03:00:00:00")
            ]
                .isSorted(timelineStart: tc("01:00:00:00"))
        ))
        
        #expect(
            try [
                tc("01:00:00:00"),
                tc("02:00:00:00"),
                tc("03:00:00:00"),
                tc("00:00:00:00"),
                tc("00:00:00:01"),
                tc("00:00:00:14"),
                tc("00:00:00:15"),
                tc("00:00:00:15"), // sequential dupe
                tc("00:00:01:00"),
                tc("00:00:01:01"),
                tc("00:00:01:23"),
                tc("00:00:02:00"),
                tc("00:01:00:05"),
                tc("00:02:00:08"),
                tc("00:23:00:10"),
                tc("00:59:59:23") // 1 frame before wrap around
            ]
                .isSorted(timelineStart: tc("01:00:00:00"))
        )
        
        #expect(!(
            try [
                tc("01:00:00:00"),
                tc("02:00:00:00"),
                tc("03:00:00:00"),
                tc("00:00:00:00"),
                tc("00:00:00:01"),
                tc("00:00:00:14"),
                tc("00:00:00:15"),
                tc("00:00:00:15"), // sequential dupe
                tc("00:00:01:00"),
                tc("00:00:01:01"),
                tc("00:00:01:23"),
                tc("00:00:02:00"),
                tc("00:01:00:05"),
                tc("00:02:00:08"),
                tc("00:23:00:10"),
                tc("00:59:59:23") // 1 frame before wrap around
            ]
                .isSorted(ascending: false, timelineStart: tc("01:00:00:00"))
        ))
        
        #expect(
            try [
                tc("00:59:59:23"), // 1 frame before wrap around
                tc("00:23:00:10"),
                tc("00:02:00:08"),
                tc("00:01:00:05"),
                tc("00:00:02:00"),
                tc("00:00:01:23"),
                tc("00:00:01:01"),
                tc("00:00:01:00"),
                tc("00:00:00:15"),
                tc("00:00:00:15"), // sequential dupe
                tc("00:00:00:14"),
                tc("00:00:00:01"),
                tc("00:00:00:00"),
                tc("03:00:00:00"),
                tc("02:00:00:00"),
                tc("01:00:00:00")
            ]
                .isSorted(ascending: false, timelineStart: tc("01:00:00:00"))
        )
    }
}

// MARK: - Helpers

extension MutableCollection where Self: RandomAccessCollection, Self: Equatable {
    /// Guarantees shuffled array is different than the input.
    fileprivate mutating func guaranteedShuffle() {
        // avoid endless loop with 0 or 1 array elements not being shuffleable
        guard count > 1 else { return }
        
        // randomize so timecode instances are out of order;
        // loop in case shuffle produces identical ordering
        var shuffled = self
        var shuffleCount = 0
        while shuffleCount == 0 || shuffled == self {
            shuffled.shuffle()
            shuffleCount += 1
        }
        self = shuffled
    }
}
