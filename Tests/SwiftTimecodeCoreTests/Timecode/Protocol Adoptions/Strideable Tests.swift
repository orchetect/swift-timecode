//
//  Strideable Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore // do NOT import as @testable in this file
import Testing

@Suite struct Timecode_Strideable_Tests {
    @Test(arguments: TimecodeFrameRate.allCases)
    func advancedBy(frameRate: TimecodeFrameRate) async throws {
        let frames = Timecode.frameCount(of: Timecode.Components(h: 1), at: frameRate).wholeFrames
        
        let advanced = try Timecode(.components(f: 00), at: frameRate)
            .advanced(by: frames)
            .components
        
        #expect(advanced == Timecode.Components(h: 1))
    }
    
    /// 24 hours stride frame count test.
    @Test(arguments: TimecodeFrameRate.allCases)
    func distanceTo_24Hours(frameRate: TimecodeFrameRate) async throws {
        let zero = Timecode(.zero, at: frameRate)
        
        let target = try Timecode(
            .components(d: 00, h: 23, m: 59, s: 59, f: frameRate.maxFrameNumberDisplayable),
            at: frameRate
        )
        
        let delta = zero.distance(to: target)
        
        #expect(delta == frameRate.maxTotalFramesExpressible(in: .max24Hours))
    }
    
    /// 100 days stride frame count test.
    @Test(arguments: TimecodeFrameRate.allCases)
    func distanceTo_100Days(frameRate: TimecodeFrameRate) async throws {
        let zero = Timecode(.zero, at: frameRate, limit: .max100Days)
        
        let target = try Timecode(
            .components(d: 99, h: 23, m: 59, s: 59, f: frameRate.maxFrameNumberDisplayable),
            at: frameRate,
            limit: .max100Days
        )
        
        let delta = zero.distance(to: target)
        
        #expect(delta == frameRate.maxTotalFramesExpressible(in: .max100Days))
    }
    
    // MARK: Integration Tests
    
    @Test
    func timecode_Strideable_Ranges() async throws {
        // Stride through & array
        
        let strideThrough = try stride(
            from: Timecode(.string("01:00:00:00"), at: .fps23_976),
            through: Timecode(.string("01:00:00:06"), at: .fps23_976),
            by: 2
        )
        var array = Array(strideThrough)
        
        #expect(array.count == 4)
        #expect(
            try array
            == [
                Timecode(.string("01:00:00:00"), at: .fps23_976),
                Timecode(.string("01:00:00:02"), at: .fps23_976),
                Timecode(.string("01:00:00:04"), at: .fps23_976),
                Timecode(.string("01:00:00:06"), at: .fps23_976)
            ]
        )
        
        // Stride to
        let strideTo = try stride(
            from: Timecode(.string("01:00:00:00"), at: .fps23_976),
            to: Timecode(.string("01:00:00:06"), at: .fps23_976),
            by: 2
        )
        array = Array(strideTo)
        
        #expect(array.count == 3)
        #expect(
            try array
            == [
                Timecode(.string("01:00:00:00"), at: .fps23_976),
                Timecode(.string("01:00:00:02"), at: .fps23_976),
                Timecode(.string("01:00:00:04"), at: .fps23_976)
            ]
        )
        
        // Strideable
        
        #expect(
            try Timecode(.string("01:00:00:00"), at: .fps23_976)
                .advanced(by: 6)
            == Timecode(.string("01:00:00:06"), at: .fps23_976)
        )
        
        #expect(
            try Timecode(.string("01:00:00:00"), at: .fps23_976)
                .distance(to: Timecode(.string("02:00:00:00"), at: .fps23_976))
            == Timecode(.string("01:00:00:00"), at: .fps23_976).frameCount.wholeFrames
        )
        
        let strs = try Array(
            stride(
                from: Timecode(.string("01:00:00:05"), at: .fps23_976),
                through: Timecode(.string("01:00:10:05"), at: .fps23_976),
                by: Timecode(.components(s: 1), at: .fps23_976).frameCount.wholeFrames
            )
        )
        .map { $0.stringValue() }
        
        #expect(strs.count == 11)
        
        let strs2 = try Array(
            stride(
                from: Timecode(.string("01:00:00:05"), at: .fps23_976),
                to: Timecode(.string("01:00:10:07"), at: .fps23_976),
                by: Timecode(.components(s: 1), at: .fps23_976).frameCount.wholeFrames
            )
        )
        .map { $0.stringValue() }
        
        #expect(strs2.count == 11)
        
        // Strideable with drop rates
        
        // TODO: add Strideable drop rates tests
        
        // Range .contains
        
        #expect(
            try (
                Timecode(.string("01:00:00:00"), at: .fps23_976)
                    ... Timecode(.string("01:00:00:06"), at: .fps23_976)
            )
            .contains(Timecode(.string("01:00:00:02"), at: .fps23_976))
        )
        #expect(
            try !(
                Timecode(.string("01:00:00:00"), at: .fps23_976)
                    ... Timecode(.string("01:00:00:06"), at: .fps23_976)
            )
            .contains(Timecode(.string("01:00:00:10"), at: .fps23_976))
        )
        #expect(
            try (Timecode(.string("01:00:00:00"), at: .fps23_976)...)
                .contains(Timecode(.string("01:00:00:02"), at: .fps23_976))
        )
        #expect(
            try (...Timecode(.string("01:00:00:06"), at: .fps23_976))
                .contains(Timecode(.string("01:00:00:02"), at: .fps23_976))
        )
        
        // (same tests, but with ~= operator instead of .contains(...) which should produce the same result)
        
        #expect(
            try (
                Timecode(.string("01:00:00:00"), at: .fps23_976)
                    ... Timecode(.string("01:00:00:06"), at: .fps23_976)
            )
                ~= Timecode(.string("01:00:00:02"), at: .fps23_976)
        )
        #expect(!(
            try Timecode(.string("01:00:00:00"), at: .fps23_976) ... Timecode(.string("01:00:00:06"), at: .fps23_976)
                ~= Timecode(.string("01:00:00:10"), at: .fps23_976)
        ))
        #expect(
            try Timecode(.string("01:00:00:00"), at: .fps23_976)...
                ~= Timecode(.string("01:00:00:02"), at: .fps23_976)
        )
        #expect(
            try ...Timecode(.string("01:00:00:06"), at: .fps23_976)
                ~= Timecode(.string("01:00:00:02"), at: .fps23_976)
        )
    }
}
