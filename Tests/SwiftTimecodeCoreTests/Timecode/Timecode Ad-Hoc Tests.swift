//
//  Timecode Ad-Hoc Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import Testing

@Suite struct TimecodeAdHocTests {
    // MARK: - Clamping
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Clamping_24HourLimit_Underflow(frameRate: TimecodeFrameRate) async {
        #expect(
            Timecode(
                .components(h: -1, m: -1, s: -1, f: -1),
                at: frameRate,
                by: .clampingComponents
            )
            .components
            == Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0)
        )
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Clamping_24HourLimit_Overflow(frameRate: TimecodeFrameRate) async {
        let clamped = Timecode(
            .components(h: 99, m: 99, s: 99, f: 10000),
            at: frameRate,
            by: .clampingComponents
        )
            .components
        
        #expect(clamped == Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: frameRate.maxFrameNumberDisplayable))
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Clamping_24HourLimit_Underflow_WithDays(frameRate: TimecodeFrameRate) async {
        #expect(
            Timecode(
                .components(d: -1, h: -1, m: -1, s: -1, f: -1),
                at: frameRate,
                by: .clampingComponents
            )
            .components
            == Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0)
        )
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Clamping_24HourLimit_Overflow_WithDays(frameRate: TimecodeFrameRate) async {
        let clamped = Timecode(
            .components(d: 99, h: 99, m: 99, s: 99, f: 10000),
            at: frameRate,
            by: .clampingComponents
        )
            .components
        
        #expect(clamped == Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: frameRate.maxFrameNumberDisplayable))
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Clamping_100DaysLimit_Underflow(frameRate: TimecodeFrameRate) async {
        #expect(
            Timecode(
                .components(h: -1, m: -1, s: -1, f: -1),
                at: frameRate,
                by: .clampingComponents
            )
            .components
            == Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0)
        )
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Clamping_100DaysLimit_Overflow(frameRate: TimecodeFrameRate) async {
        let clamped = Timecode(
            .components(h: 99, m: 99, s: 99, f: 10000),
            at: frameRate,
            by: .clampingComponents
        )
            .components
        
        #expect(clamped == Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: frameRate.maxFrameNumberDisplayable))
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Clamping_100DaysLimit_Underflow_WithDays(frameRate: TimecodeFrameRate) async {
        #expect(
            Timecode(
                .components(d: -1, h: -1, m: -1, s: -1, f: -1),
                at: frameRate,
                limit: .max100Days,
                by: .clampingComponents
            )
            .components
            == Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0)
        )
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Clamping_100DaysLimit_Overflow_WithDays(frameRate: TimecodeFrameRate) async {
        let clamped = Timecode(
            .components(d: 99, h: 99, m: 99, s: 99, f: 10000),
            at: frameRate,
            limit: .max100Days,
            by: .clampingComponents
        )
            .components
        
        #expect(clamped == Timecode.Components(d: 99, h: 23, m: 59, s: 59, f: frameRate.maxFrameNumberDisplayable))
    }
    
    // MARK: - Wrapping
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Wrapping_24HourLimit_Overflow(frameRate: TimecodeFrameRate) async {
        let wrapped = Timecode(
            .components(d: 1),
            at: frameRate,
            by: .wrapping
        )
            .components
        
        let result = Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0)
        
        #expect(wrapped == result)
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Wrapping_24HourLimit_Underflow(frameRate: TimecodeFrameRate) async {
        let wrapped = Timecode(
            .components(f: -1),
            at: frameRate,
            by: .wrapping
        )
            .components
        
        let result = Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: frameRate.maxFrameNumberDisplayable, sf: 0)
        
        #expect(wrapped == result)
    }
    
    // 24 hour - testing with days
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Wrapping_24HourLimit_Overflow_WithDays(frameRate: TimecodeFrameRate) async {
        let wrapped = Timecode(
            .components(d: 1, h: 2, m: 30, s: 20, f: 0),
            at: frameRate,
            by: .wrapping
        )
            .components
        
        let result = Timecode.Components(d: 0, h: 2, m: 30, s: 20, f: 0)
        
        #expect(wrapped == result)
    }
    
    // 100 days
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_Wrapping_100DaysLimit_Underflow_WithDays(frameRate: TimecodeFrameRate) async {
        let wrapped = Timecode(
            .components(d: -1),
            at: frameRate,
            limit: .max100Days,
            by: .wrapping
        )
            .components
        
        let result = Timecode.Components(d: 99, h: 0, m: 0, s: 0, f: 0)
        
        #expect(wrapped == result)
    }
}
