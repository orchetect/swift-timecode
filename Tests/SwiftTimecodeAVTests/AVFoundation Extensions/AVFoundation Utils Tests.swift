//
//  AVFoundation Utils Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS) && !os(visionOS)

import AVFoundation
import SwiftTimecodeAV
import Testing

@Suite struct AVFoundationUtils_Tests {
    @Test
    func cmTimeRange_timecodeRange() async throws {
        let s10 = CMTime(seconds: 10, preferredTimescale: 600)
        let s9 = CMTime(seconds: 9, preferredTimescale: 600)
        
        // valid
        
        #expect(
            try CMTimeRange(start: s10, end: s10).timecodeRange(at: .fps30)
                == Timecode(.components(s: 10), at: .fps30) ... Timecode(.components(s: 10), at: .fps30)
        )
        
        #expect(
            try CMTimeRange(start: s10, duration: s10).timecodeRange(at: .fps30)
                == Timecode(.components(s: 10), at: .fps30) ... Timecode(.components(s: 20), at: .fps30)
        )
        
        // invalid
        
        #expect(throws: (any Error).self) {
            try CMTimeRange(start: s10, end: s9).timecodeRange(at: .fps30)
        }
    }
}

#endif
