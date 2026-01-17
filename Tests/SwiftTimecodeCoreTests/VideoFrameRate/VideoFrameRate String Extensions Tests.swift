//
//  VideoFrameRate String Extensions Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

@testable import SwiftTimecodeCore
import Testing

@Suite struct VideoFrameRate_StringExtensions_Tests {
    @Test
    func string_videoFrameRate() async {
        // do a spot-check to ensure this functions as expected
        
        #expect("24p".videoFrameRate == .fps24p)
        #expect("23.98p".videoFrameRate == .fps23_98p)
        #expect("29.97p".videoFrameRate == .fps29_97p)
        
        #expect("".videoFrameRate == nil)
        #expect(" ".videoFrameRate == nil)
        #expect("BogusString".videoFrameRate == nil)
    }
}
