//
//  TimecodeFrameRate Conversions Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import CoreMedia
import Numerics
import SwiftTimecodeCore
import Testing

@Suite struct TimecodeFrameRate_Conversions_Tests {
    @Test(arguments: TimecodeFrameRate.allCases)
    func init_rate_allCases(frameRate: TimecodeFrameRate) async {
        let num = frameRate.rate.numerator
        let den = frameRate.rate.denominator
        let drop = frameRate.isDrop
        
        #expect(TimecodeFrameRate(rate: Fraction(num, den), drop: drop) == frameRate)
    }
    
    @Test
    func init_rate_Typical() async {
        // 24
        #expect(TimecodeFrameRate(rate: Fraction(24, 1), drop: false) == .fps24)
        #expect(TimecodeFrameRate(rate: Fraction(240, 10), drop: false) == .fps24)
        
        // 24d is not a valid frame rate
        #expect(TimecodeFrameRate(rate: Fraction(24, 1), drop: true) == nil)
        
        // 30
        #expect(TimecodeFrameRate(rate: Fraction(30, 1), drop: false) == .fps30)
        #expect(TimecodeFrameRate(rate: Fraction(300, 10), drop: false) == .fps30)
        
        // 30d
        #expect(TimecodeFrameRate(rate: Fraction(30, 1), drop: true) == .fps30d)
        
        // edge cases
        
        // check for division by zero etc.
        #expect(TimecodeFrameRate(rate: Fraction(0, 0), drop: false) == nil)
        #expect(TimecodeFrameRate(rate: Fraction(1, 0), drop: false) == nil)
        #expect(TimecodeFrameRate(rate: Fraction(0, 1), drop: false) == nil)
        
        // negative numbers
        #expect(TimecodeFrameRate(rate: Fraction(0, -1), drop: false) == nil)
        #expect(TimecodeFrameRate(rate: Fraction(-1, 0), drop: false) == nil)
        #expect(TimecodeFrameRate(rate: Fraction(-1, -1), drop: false) == nil)
        #expect(TimecodeFrameRate(rate: Fraction(-30, -1), drop: false) == .fps30)
        #expect(TimecodeFrameRate(rate: Fraction(-30, 1), drop: false) == nil)
        #expect(TimecodeFrameRate(rate: Fraction(30, -1), drop: false) == nil)
        
        // nonsense
        #expect(TimecodeFrameRate(rate: Fraction(12345, 1000), drop: false) == nil)
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func init_frameDuration_allCases(frameRate: TimecodeFrameRate) async {
        let num = frameRate.frameDuration.numerator
        let den = frameRate.frameDuration.denominator
        let drop = frameRate.isDrop
        
        #expect(TimecodeFrameRate(frameDuration: Fraction(num, den), drop: drop) == frameRate)
    }
    
    @Test
    func init_frameDuration_Typical() async {
        // 24
        #expect(TimecodeFrameRate(frameDuration: Fraction(1, 24), drop: false) == .fps24)
        #expect(TimecodeFrameRate(frameDuration: Fraction(10, 240), drop: false) == .fps24)
        
        // 24d is not a valid frame rate
        #expect(TimecodeFrameRate(frameDuration: Fraction(1, 24), drop: true) == nil)
        
        // 30
        #expect(TimecodeFrameRate(frameDuration: Fraction(1, 30), drop: false) == .fps30)
        #expect(TimecodeFrameRate(frameDuration: Fraction(10, 300), drop: false) == .fps30)
        
        // 30d
        #expect(TimecodeFrameRate(frameDuration: Fraction(1, 30), drop: true) == .fps30d)
        
        // edge cases
        
        // check for division by zero etc.
        #expect(TimecodeFrameRate(frameDuration: Fraction(0, 0), drop: false) == nil)
        #expect(TimecodeFrameRate(frameDuration: Fraction(0, 1), drop: false) == nil)
        #expect(TimecodeFrameRate(frameDuration: Fraction(1, 0), drop: false) == nil)
        
        // negative numbers
        #expect(TimecodeFrameRate(frameDuration: Fraction(-1, 0), drop: false) == nil)
        #expect(TimecodeFrameRate(frameDuration: Fraction(0, -1), drop: false) == nil)
        #expect(TimecodeFrameRate(frameDuration: Fraction(-1, -1), drop: false) == nil)
        #expect(TimecodeFrameRate(frameDuration: Fraction(-1, -30), drop: false) == .fps30)
        #expect(TimecodeFrameRate(frameDuration: Fraction(1, -30), drop: false) == nil)
        #expect(TimecodeFrameRate(frameDuration: Fraction(-1, 30), drop: false) == nil)
        
        // nonsense
        #expect(TimecodeFrameRate(frameDuration: Fraction(1000, 12345), drop: false) == nil)
    }
}

#if canImport(CoreMedia)
import CoreMedia

@Suite struct TimecodeFrameRate_Conversions_CMTime_Tests {
    @Test
    func init_rate_CMTime() async {
        #expect(
            TimecodeFrameRate(
                rate: CMTime(value: 30000, timescale: 1001),
                drop: false
            )
            == .fps29_97
        )
        #expect(
            TimecodeFrameRate(
                rate: CMTime(value: 30000, timescale: 1001),
                drop: true
            )
            == .fps29_97d
        )
    }
    
    @Test
    func init_frameDuration_CMTime() async {
        #expect(
            TimecodeFrameRate(
                frameDuration: CMTime(value: 1001, timescale: 30000),
                drop: false
            )
            == .fps29_97
        )
        #expect(
            TimecodeFrameRate(
                frameDuration: CMTime(value: 1001, timescale: 30000),
                drop: true
            )
            == .fps29_97d
        )
    }
    
    @Test
    func rateCMTime() async throws {
        #expect(
            TimecodeFrameRate.fps29_97.rateCMTime
                == CMTime(value: 30000, timescale: 1001)
        )
    }
    
    @Test
    func frameDurationCMTime_SpotCheck() async throws {
        #expect(
            TimecodeFrameRate.fps29_97.frameDurationCMTime
                == CMTime(value: 1001, timescale: 30000)
        )
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func frameDurationCMTime(frameRate: TimecodeFrameRate) async throws {
        // ensure the CMTime instance returns correct 1 frame duration in seconds.
        // due to floating-point dithering, it tends to be accurate up to
        // 16 decimal places when stored in a Double (1 picosecond or less)
        
        let cmTimeSeconds = frameRate.frameDurationCMTime.seconds
        
        let oneFrameDuration = try Timecode(.components(f: 1), at: frameRate)
            .realTimeValue
        
        #expect(cmTimeSeconds.isApproximatelyEqual(to: oneFrameDuration, absoluteTolerance: 0.0000_0000_0000_0001))
    }
}
#endif
