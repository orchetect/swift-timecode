//
//  Codable Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftTimecodeCore // do NOT import as @testable in this file
import Testing

@Suite struct Timecode_Codable_Tests {
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Codable(frameRate: TimecodeFrameRate) async throws {
        // set up JSON coders with default settings
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        // set up a timecode object that has all non-defaults
        let tc = try Timecode(
            .string("1 12:34:56:11.85"),
            at: frameRate,
            base: .max100SubFrames,
            limit: .max100Days
        )
        
        // encode
        let encoded = try encoder.encode(tc)
        
        // decode
        let decoded = try decoder.decode(Timecode.self, from: encoded)
        
        // compare original to reconstructed
        #expect(tc == decoded)
        #expect(tc.components == decoded.components)
        #expect(tc.properties == decoded.properties)
    }
}
