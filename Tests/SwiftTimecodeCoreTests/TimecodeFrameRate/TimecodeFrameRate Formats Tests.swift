//
//  TimecodeFrameRate Formats Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Numerics
import SwiftTimecodeCore
import Testing

@Suite struct TimecodeFrameRate_Formats_Tests {
    @Test(arguments: TimecodeFrameRate.allCases)
    func aafMetadata(frameRate: TimecodeFrameRate) async throws {
        // ensure the EditRate calculation is correct
        // due to floating-point dithering, it tends to be accurate up to
        // 16 decimal places when stored in a Double (1 picosecond or less)
        
        let editRateComponents = frameRate.aafMetadata.editRate
            .split(separator: "/")
            .compactMap { Int($0) }
        
        try #require(editRateComponents.count == 2, "\(frameRate) editRate parse failed.")
        
        let editRateSeconds = Double(editRateComponents[1]) / Double(editRateComponents[0])
        
        let oneFrameDuration = try Timecode(.components(f: 1), at: frameRate)
            .realTimeValue
        
        #expect(editRateSeconds.isApproximatelyEqual(to: oneFrameDuration, absoluteTolerance: 0.0000_0000_0000_0001))
    }
}
