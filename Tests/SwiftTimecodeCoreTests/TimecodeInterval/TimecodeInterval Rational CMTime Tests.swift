//
//  TimecodeInterval Rational CMTime Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import CoreMedia
import SwiftTimecodeCore
import Testing

@Suite struct TimecodeInterval_Rational_CMTime_Tests {
    @Test
    func timecodeInterval_init_cmTime() async throws {
        let ti = try TimecodeInterval(
            CMTime(value: 60, timescale: 30),
            at: .fps24
        )
        
        #expect(ti.sign == .plus)
        
        #expect(try ti.absoluteInterval == Timecode(.components(s: 2), at: .fps24))
    }
    
    @Test
    func cmTime() async throws {
        let ti = try TimecodeInterval(
            Timecode(.components(s: 2), at: .fps24)
        )
        
        let cmTime = ti.cmTimeValue
        
        #expect(cmTime.seconds.sign == .plus)
        #expect(cmTime.value == 2)
        #expect(cmTime.timescale == 1)
    }
    
    @Test
    func cmTime_timecodeInterval() async throws {
        let ti = try CMTime(value: 60, timescale: 30).timecodeInterval(at: .fps24)
        
        #expect(ti.sign == .plus)
        
        #expect(try ti.absoluteInterval == Timecode(.components(s: 2), at: .fps24))
    }
}
