//
//  Timecode AVAsset Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS) && !os(visionOS)

import AVFoundation
@testable import SwiftTimecodeAV
import Testing
import TestingExtensions

@Suite struct Timecode_AVAsset_Tests {
    // NOTE:
    // These tests are just to verify baseline results using this API on `Timecode`.
    // More extensive AVAsset parsing tests are in AVAsset Extensions Tests.swift
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    @Test
    func timecode_init_startOfAsset() async throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        
        let timecode = try await Timecode(.avAsset(asset, .start))
        #expect(timecode.components == Timecode.Components(m: 58, s: 40))
        #expect(timecode.frameRate == .fps23_976)
    }
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    @Test
    func timecode_init_durationOfAsset() async throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        
        let timecode = try await Timecode(.avAsset(asset, .duration))
        #expect(timecode.components == Timecode.Components(m: 24, s: 10, f: 19, sf: 03))
        #expect(timecode.frameRate == .fps23_976)
    }
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    @Test
    func timecode_init_endOfAsset() async throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        
        let timecode = try await Timecode(.avAsset(asset, .end))
        #expect(timecode.components == Timecode.Components(h: 1, m: 22, s: 50, f: 19, sf: 03))
        #expect(timecode.frameRate == .fps23_976)
    }
}

#endif
