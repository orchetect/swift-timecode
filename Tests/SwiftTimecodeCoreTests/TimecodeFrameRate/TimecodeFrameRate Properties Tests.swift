//
//  TimecodeFrameRate Properties Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

@testable import SwiftTimecodeCore
import Testing

@Suite struct TimecodeFrameRate_Properties_Tests {
    @Test
    func properties() async {
        // spot-check that properties behave as expected

        let frameRate: TimecodeFrameRate = .fps30

        #expect(frameRate.stringValue == "30")

        #expect(frameRate.stringValueVerbose == "30 fps")

        #expect(TimecodeFrameRate(stringValue: "30") == frameRate)

        #expect(frameRate.numberOfDigits == 2)

        #expect(frameRate.maxFrameNumberDisplayable == 29)

        #expect(
            frameRate.maxTotalFrames(in: .max24Hours)
                == 2_592_000
        )

        #expect(
            frameRate.maxTotalFrames(in: .max100Days)
                == 2_592_000 * 100
        )

        #expect(
            frameRate.maxTotalFramesExpressible(in: .max24Hours)
                == 2_592_000 - 1
        )

        #expect(
            frameRate.maxTotalFramesExpressible(in: .max100Days)
                == (2_592_000 * 100) - 1
        )

        #expect(
            frameRate.maxTotalSubFrames(
                in: .max24Hours,
                base: .max80SubFrames
            )
                == 2_592_000 * 80
        )

        // these integers result in overflow on armv7/i386 (32-bit arch)
        #if !(arch(arm) || arch(i386))
        #expect(
            frameRate.maxTotalSubFrames(
                in: .max100Days,
                base: .max80SubFrames
            )
                == 2_592_000 * 100 * 80
        )

        #expect(
            frameRate.maxSubFrameCountExpressible(
                in: .max100Days,
                base: .max80SubFrames
            )
                == (2_592_000 * 100 * 80) - 1
        )
        #endif

        #expect(
            frameRate.maxSubFrameCountExpressible(
                in: .max24Hours,
                base: .max80SubFrames
            )
                == (2_592_000 * 80) - 1
        )

        #expect(frameRate.maxFrames == 30)

        #expect(frameRate.frameRateForElapsedFramesCalculation == 30.0)

        #expect(frameRate.frameRateForRealTimeCalculation == 30.0)

        #expect(frameRate.framesDroppedPerMinute == 0.0)
    }

    @Test
    func initStringValue() async {
        #expect(TimecodeFrameRate(stringValue: "23.976") == .fps23_976)
        #expect(TimecodeFrameRate(stringValue: "29.97d") == .fps29_97d)

        #expect(TimecodeFrameRate(stringValue: "") == nil)
        #expect(TimecodeFrameRate(stringValue: " ") == nil)
        #expect(TimecodeFrameRate(stringValue: "BogusString") == nil)
    }
}
