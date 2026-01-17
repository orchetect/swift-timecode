//
//  VideoFrameRate Conversions Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Numerics
import SwiftTimecodeCore // do NOT import as @testable in this file
import Testing

@Suite struct VideoFrameRate_Conversions_Tests {
    @Test
    func init_raw_nonStrict() async {
        #expect(VideoFrameRate(fps: 23, strict: false) == nil)
        #expect(VideoFrameRate(fps: 23.9, strict: false) == .fps23_98p)
        #expect(VideoFrameRate(fps: 23.98, strict: false) == .fps23_98p)
        #expect(VideoFrameRate(fps: 23.976, strict: false) == .fps23_98p)
        #expect(VideoFrameRate(fps: 23.976023976, strict: false) == .fps23_98p)
        
        #expect(VideoFrameRate(fps: 24, strict: false) == .fps24p)
        
        #expect(VideoFrameRate(fps: 25, strict: false) == .fps25p)
        #expect(VideoFrameRate(fps: 25, interlaced: true, strict: false) == .fps25i)
        #expect(VideoFrameRate(fps: 24.997648, interlaced: false, strict: false) == .fps25p) // VFR-like
        
        #expect(VideoFrameRate(fps: 29, strict: false) == nil)
        #expect(VideoFrameRate(fps: 29.9, strict: false) == .fps29_97p)
        #expect(VideoFrameRate(fps: 29.97, strict: false) == .fps29_97p)
        #expect(VideoFrameRate(fps: 29.97002997, strict: false) == .fps29_97p)
        
        #expect(VideoFrameRate(fps: 29, interlaced: true, strict: false) == nil)
        #expect(VideoFrameRate(fps: 29.9, interlaced: true, strict: false) == .fps29_97i)
        #expect(VideoFrameRate(fps: 29.97, interlaced: true, strict: false) == .fps29_97i)
        #expect(VideoFrameRate(fps: 29.97002997, interlaced: true, strict: false) == .fps29_97i)
        
        #expect(VideoFrameRate(fps: 30, strict: false) == .fps30p)
        
        #expect(VideoFrameRate(fps: 47, strict: false) == nil)
        #expect(VideoFrameRate(fps: 47.9, strict: false) == .fps47_95p)
        #expect(VideoFrameRate(fps: 47.95, strict: false) == .fps47_95p)
        #expect(VideoFrameRate(fps: 47.952, strict: false) == .fps47_95p)
        #expect(VideoFrameRate(fps: 47.952047952, strict: false) == .fps47_95p)
        
        #expect(VideoFrameRate(fps: 48, strict: false) == .fps48p)
        
        #expect(VideoFrameRate(fps: 50, strict: false) == .fps50p)
        #expect(VideoFrameRate(fps: 50, interlaced: true, strict: false) == .fps50i)
        
        #expect(VideoFrameRate(fps: 59, strict: false) == nil)
        #expect(VideoFrameRate(fps: 59.9, strict: false) == .fps59_94p)
        #expect(VideoFrameRate(fps: 59.94, strict: false) == .fps59_94p)
        #expect(VideoFrameRate(fps: 59.9400599401, strict: false) == .fps59_94p)
        
        #expect(VideoFrameRate(fps: 59, interlaced: true, strict: false) == nil)
        #expect(VideoFrameRate(fps: 59.9, interlaced: true, strict: false) == .fps59_94i)
        #expect(VideoFrameRate(fps: 59.94, interlaced: true, strict: false) == .fps59_94i)
        #expect(VideoFrameRate(fps: 59.9400599401, interlaced: true, strict: false) == .fps59_94i)
        
        #expect(VideoFrameRate(fps: 60, strict: false) == .fps60p)
        
        #expect(VideoFrameRate(fps: 95, strict: false) == nil)
        #expect(VideoFrameRate(fps: 95.9, strict: false) == .fps95_9p)
        #expect(VideoFrameRate(fps: 95.904, strict: false) == .fps95_9p)
        #expect(VideoFrameRate(fps: 95.9040959041, strict: false) == .fps95_9p)
        
        #expect(VideoFrameRate(fps: 96, strict: false) == .fps96p)
        
        #expect(VideoFrameRate(fps: 100, strict: false) == .fps100p)
        
        #expect(VideoFrameRate(fps: 119, strict: false) == nil)
        #expect(VideoFrameRate(fps: 119.8, strict: false) == .fps119_88p)
        #expect(VideoFrameRate(fps: 119.88, strict: false) == .fps119_88p)
        #expect(VideoFrameRate(fps: 119.8801198801, strict: false) == .fps119_88p)
        
        #expect(VideoFrameRate(fps: 120, strict: false) == .fps120p)
    }
    
    @Test
    func init_raw_strict() async {
        #expect(VideoFrameRate(fps: 23, strict: true) == nil)
        #expect(VideoFrameRate(fps: 23.9, strict: true) == nil)
        #expect(VideoFrameRate(fps: 23.98, strict: true) == nil)
        #expect(VideoFrameRate(fps: 23.976, strict: true) == .fps23_98p)
        #expect(VideoFrameRate(fps: 23.976023976, strict: true) == .fps23_98p)
        
        #expect(VideoFrameRate(fps: 24, strict: true) == .fps24p)
        
        #expect(VideoFrameRate(fps: 25, strict: true) == .fps25p)
        #expect(VideoFrameRate(fps: 25, interlaced: true, strict: true) == .fps25i)
        #expect(VideoFrameRate(fps: 24.997648, interlaced: false, strict: true) == nil) // VFR-like
        
        #expect(VideoFrameRate(fps: 29, strict: true) == nil)
        #expect(VideoFrameRate(fps: 29.9, strict: true) == nil)
        #expect(VideoFrameRate(fps: 29.97, strict: true) == .fps29_97p)
        #expect(VideoFrameRate(fps: 29.97002997, strict: true) == .fps29_97p)
        
        #expect(VideoFrameRate(fps: 29, interlaced: true, strict: true) == nil)
        #expect(VideoFrameRate(fps: 29.9, interlaced: true, strict: true) == nil)
        #expect(VideoFrameRate(fps: 29.97, interlaced: true, strict: true) == .fps29_97i)
        #expect(VideoFrameRate(fps: 29.97002997, interlaced: true, strict: true) == .fps29_97i)
        
        #expect(VideoFrameRate(fps: 30, strict: true) == .fps30p)
        
        #expect(VideoFrameRate(fps: 47, strict: true) == nil)
        #expect(VideoFrameRate(fps: 47.9, strict: true) == nil)
        #expect(VideoFrameRate(fps: 47.95, strict: true) == nil)
        #expect(VideoFrameRate(fps: 47.952, strict: true) == .fps47_95p)
        #expect(VideoFrameRate(fps: 47.952047952, strict: true) == .fps47_95p)
        
        #expect(VideoFrameRate(fps: 48, strict: true) == .fps48p)
        
        #expect(VideoFrameRate(fps: 50, strict: true) == .fps50p)
        #expect(VideoFrameRate(fps: 50, interlaced: true, strict: true) == .fps50i)
        
        #expect(VideoFrameRate(fps: 59, strict: true) == nil)
        #expect(VideoFrameRate(fps: 59.9, strict: true) == nil)
        #expect(VideoFrameRate(fps: 59.94, strict: true) == .fps59_94p)
        #expect(VideoFrameRate(fps: 59.9400599401, strict: true) == .fps59_94p)
        
        #expect(VideoFrameRate(fps: 59, interlaced: true, strict: true) == nil)
        #expect(VideoFrameRate(fps: 59.9, interlaced: true, strict: true) == nil)
        #expect(VideoFrameRate(fps: 59.94, interlaced: true, strict: true) == .fps59_94i)
        #expect(VideoFrameRate(fps: 59.9400599401, interlaced: true, strict: true) == .fps59_94i)
        
        #expect(VideoFrameRate(fps: 60, strict: true) == .fps60p)
        
        #expect(VideoFrameRate(fps: 95, strict: true) == nil)
        #expect(VideoFrameRate(fps: 95.9, strict: true) == nil)
        #expect(VideoFrameRate(fps: 95.904, strict: true) == .fps95_9p)
        #expect(VideoFrameRate(fps: 95.9040959041, strict: true) == .fps95_9p)
        
        #expect(VideoFrameRate(fps: 96, strict: true) == .fps96p)
        
        #expect(VideoFrameRate(fps: 100, strict: true) == .fps100p)
        
        #expect(VideoFrameRate(fps: 119, strict: true) == nil)
        #expect(VideoFrameRate(fps: 119.8, strict: true) == nil)
        #expect(VideoFrameRate(fps: 119.88, strict: true) == .fps119_88p)
        #expect(VideoFrameRate(fps: 119.8801198801, strict: true) == .fps119_88p)
        
        #expect(VideoFrameRate(fps: 120, strict: true) == .fps120p)
    }
    
    @Test
    func init_raw_invalid_nonStrict() async {
        #expect(VideoFrameRate(fps: 0.0, strict: false) == nil)
        #expect(VideoFrameRate(fps: 1.0, strict: false) == nil)
        
        #expect(VideoFrameRate(fps: 26.0, strict: false) == nil)
        
        #expect(VideoFrameRate(fps: 29.0, strict: false) == nil)
        #expect(VideoFrameRate(fps: 29.9, strict: false) != nil)
        
        #expect(VideoFrameRate(fps: 30.1, strict: false) == nil)
        #expect(VideoFrameRate(fps: 30.5, strict: false) == nil)
        #expect(VideoFrameRate(fps: 31.0, strict: false) == nil)
        
        #expect(VideoFrameRate(fps: 59.0, strict: false) == nil)
        #expect(VideoFrameRate(fps: 59.9, strict: false) != nil)
        #expect(VideoFrameRate(fps: 60.1, strict: false) == nil)
        #expect(VideoFrameRate(fps: 60.5, strict: false) == nil)
        #expect(VideoFrameRate(fps: 61.0, strict: false) == nil)
        
        #expect(VideoFrameRate(fps: 95.8, strict: false) == nil)
        #expect(VideoFrameRate(fps: 96.1, strict: false) == nil)
        #expect(VideoFrameRate(fps: 97.0, strict: false) == nil)
        
        #expect(VideoFrameRate(fps: 119.0, strict: false) == nil)
        #expect(VideoFrameRate(fps: 119.8, strict: false) != nil)
        
        #expect(VideoFrameRate(fps: 120.1, strict: false) == nil)
        #expect(VideoFrameRate(fps: 120.5, strict: false) == nil)
        #expect(VideoFrameRate(fps: 121.0, strict: false) == nil)
    }
    
    @Test
    func init_raw_invalid_strict() async {
        #expect(VideoFrameRate(fps: 0.0, strict: true) == nil)
        #expect(VideoFrameRate(fps: 1.0, strict: true) == nil)
        
        #expect(VideoFrameRate(fps: 26.0, strict: true) == nil)
        
        #expect(VideoFrameRate(fps: 29.0, strict: true) == nil)
        #expect(VideoFrameRate(fps: 29.9, strict: true) == nil)
        
        #expect(VideoFrameRate(fps: 30.1, strict: true) == nil)
        #expect(VideoFrameRate(fps: 30.5, strict: true) == nil)
        #expect(VideoFrameRate(fps: 31.0, strict: true) == nil)
        
        #expect(VideoFrameRate(fps: 59.0, strict: true) == nil)
        #expect(VideoFrameRate(fps: 59.9, strict: true) == nil)
        #expect(VideoFrameRate(fps: 60.1, strict: true) == nil)
        #expect(VideoFrameRate(fps: 60.5, strict: true) == nil)
        #expect(VideoFrameRate(fps: 61.0, strict: true) == nil)
        
        #expect(VideoFrameRate(fps: 95.8, strict: true) == nil)
        #expect(VideoFrameRate(fps: 96.1, strict: true) == nil)
        #expect(VideoFrameRate(fps: 97.0, strict: true) == nil)
        
        #expect(VideoFrameRate(fps: 119.0, strict: true) == nil)
        #expect(VideoFrameRate(fps: 119.8, strict: true) == nil)
        
        #expect(VideoFrameRate(fps: 120.1, strict: true) == nil)
        #expect(VideoFrameRate(fps: 120.5, strict: true) == nil)
        #expect(VideoFrameRate(fps: 121.0, strict: true) == nil)
    }
    
    @Test(arguments: VideoFrameRate.allCases)
    func init_rate_allCases(frameRate: VideoFrameRate) async {
        let num = frameRate.rate.numerator
        let den = frameRate.rate.denominator
        let interlaced = frameRate.isInterlaced
        
        #expect(VideoFrameRate(rate: Fraction(num, den), interlaced: interlaced) == frameRate)
    }
    
    @Test
    func init_rate_Typical() async {
        // 24p
        #expect(
            VideoFrameRate(rate: Fraction(24, 1))
            == .fps24p
        )
        #expect(
            VideoFrameRate(rate: Fraction(240, 10))
                == .fps24p
        )
        
        // 25p
        #expect(
            VideoFrameRate(rate: Fraction(25, 1), interlaced: false)
                == .fps25p
        )
        #expect(
            VideoFrameRate(rate: Fraction(250, 10), interlaced: false)
                == .fps25p
        )
        
        // 25i
        #expect(
            VideoFrameRate(rate: Fraction(25, 1), interlaced: true)
                == .fps25i
        )
        #expect(
            VideoFrameRate(rate: Fraction(250, 10), interlaced: true)
                == .fps25i
        )
        
        // 30p
        #expect(
            VideoFrameRate(rate: Fraction(30, 1))
                == .fps30p
        )
        #expect(
            VideoFrameRate(rate: Fraction(300, 10))
                == .fps30p
        )
        
        // edge cases
        
        // check for division by zero etc.
        #expect(VideoFrameRate(rate: Fraction(0, 0)) == nil)
        #expect(VideoFrameRate(rate: Fraction(1, 0)) == nil)
        #expect(VideoFrameRate(rate: Fraction(0, 1)) == nil)
        
        // negative numbers
        #expect(VideoFrameRate(rate: Fraction(0, -1)) == nil)
        #expect(VideoFrameRate(rate: Fraction(-1, 0)) == nil)
        #expect(VideoFrameRate(rate: Fraction(-1, -1)) == nil)
        #expect(VideoFrameRate(rate: Fraction(-30, -1)) == .fps30p)
        #expect(VideoFrameRate(rate: Fraction(-30, 1)) == nil)
        #expect(VideoFrameRate(rate: Fraction(30, -1)) == nil)
        
        // nonsense
        #expect(VideoFrameRate(rate: Fraction(12345, 1000)) == nil)
    }
    
    @Test(arguments: VideoFrameRate.allCases)
    func init_frameDuration_allCases(frameRate: VideoFrameRate) async {
        let num = frameRate.frameDuration.numerator
        let den = frameRate.frameDuration.denominator
        let interlaced = frameRate.isInterlaced
        
        #expect(VideoFrameRate(frameDuration: Fraction(num, den), interlaced: interlaced) == frameRate)
    }
    
    @Test
    func init_frameDuration_Typical() async {
        // 24p
        #expect(
            VideoFrameRate(frameDuration: Fraction(1, 24))
                == .fps24p
        )
        #expect(
            VideoFrameRate(frameDuration: Fraction(10, 240))
                == .fps24p
        )
        
        // 25p
        #expect(
            VideoFrameRate(frameDuration: Fraction(1, 25), interlaced: false)
                == .fps25p
        )
        #expect(
            VideoFrameRate(frameDuration: Fraction(10, 250), interlaced: false)
                == .fps25p
        )
        
        // 25i
        #expect(
            VideoFrameRate(frameDuration: Fraction(1, 25), interlaced: true)
                == .fps25i
        )
        #expect(
            VideoFrameRate(frameDuration: Fraction(10, 250), interlaced: true)
                == .fps25i
        )
        
        // 30p
        #expect(
            VideoFrameRate(frameDuration: Fraction(1, 30))
                == .fps30p
        )
        #expect(
            VideoFrameRate(frameDuration: Fraction(10, 300))
                == .fps30p
        )
        
        // edge cases
        
        // check for division by zero etc.
        #expect(VideoFrameRate(frameDuration: Fraction(0, 0)) == nil)
        #expect(VideoFrameRate(frameDuration: Fraction(0, 1)) == nil)
        #expect(VideoFrameRate(frameDuration: Fraction(1, 0)) == nil)
        
        // negative numbers
        #expect(VideoFrameRate(frameDuration: Fraction(-1, 0)) == nil)
        #expect(VideoFrameRate(frameDuration: Fraction(0, -1)) == nil)
        #expect(VideoFrameRate(frameDuration: Fraction(-1, -1)) == nil)
        #expect(VideoFrameRate(frameDuration: Fraction(-1, -30)) == .fps30p)
        #expect(VideoFrameRate(frameDuration: Fraction(1, -30)) == nil)
        #expect(VideoFrameRate(frameDuration: Fraction(-1, 30)) == nil)
        
        // nonsense
        #expect(VideoFrameRate(frameDuration: Fraction(1000, 12345)) == nil)
    }
}

#if canImport(CoreMedia)
import CoreMedia

@Suite struct VideoFrameRate_Conversions_CMTime_Tests {
    @Test
    func init_rate_CMTime() async {
        #expect(
            VideoFrameRate(
                rate: CMTime(value: 30000, timescale: 1001),
                interlaced: false
            )
            == .fps29_97p
        )
        #expect(
            VideoFrameRate(
                rate: CMTime(value: 30000, timescale: 1001),
                interlaced: true
            )
            == .fps29_97i
        )
    }
    
    @Test
    func init_frameDuration_CMTime() async {
        #expect(
            VideoFrameRate(
                frameDuration: CMTime(value: 1001, timescale: 30000),
                interlaced: false
            )
            == .fps29_97p
        )
        #expect(
            VideoFrameRate(
                frameDuration: CMTime(value: 1001, timescale: 30000),
                interlaced: true
            )
            == .fps29_97i
        )
    }
    
    @Test
    func rateCMTime() async throws {
        #expect(
            VideoFrameRate.fps29_97p.rateCMTime
                == CMTime(value: 30000, timescale: 1001)
        )
    }
    
    @Test
    func frameDurationCMTime_SpotCheck() async throws {
        #expect(
            VideoFrameRate.fps29_97p.frameDurationCMTime
            == CMTime(value: 1001, timescale: 30000)
        )
    }
    
    @Test(arguments: VideoFrameRate.allCases)
    func frameDurationCMTime(frameRate: VideoFrameRate) async throws {
        // ensure the CMTime instance returns correct 1 frame duration in seconds.
        // due to floating-point dithering, it tends to be accurate up to
        // 16 decimal places when stored in a Double (1 picosecond or less)
        
        let cmTimeSeconds = frameRate.frameDurationCMTime.seconds
        
        let tcFrameRate = try #require(frameRate.timecodeFrameRate(drop: false))
        
        let oneFrameDuration = try Timecode(.components(f: 1), at: tcFrameRate)
            .realTimeValue
        
        #expect(cmTimeSeconds.isApproximatelyEqual(to: oneFrameDuration, absoluteTolerance: 0.0000_0000_0000_0001))
    }
}
#endif
