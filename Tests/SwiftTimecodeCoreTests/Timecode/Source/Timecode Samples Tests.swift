//
//  Timecode Samples Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore // do NOT import as @testable in this file
import Testing

@Suite struct Timecode_Source_Samples_Tests {
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_init_Samples_Exactly(frameRate: TimecodeFrameRate) async throws {
        let tc = try Timecode(
            .samples(48000 * 2, sampleRate: 48000),
            at: frameRate
        )
        
        // don't imperatively check each result, just make sure that a value was set;
        // setter logic is unit-tested elsewhere, we just want to check the Timecode.init interface here.
        #expect(tc.seconds != 0)
    }
    
    @Test
    func timecode_init_Samples_Clamping() async {
        let tc = Timecode(
            .samples(
                4_147_200_000 + 172_800_000, // 25 hours @ 24fps
                sampleRate: 48000
            ),
            at: .fps24,
            by: .clamping
        )
        
        #expect(
            tc.components
                == Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    @Test
    func timecode_init_Samples_Wrapping() async {
        let tc = Timecode(
            .samples(
                4_147_200_000 + 172_800_000, // 25 hours @ 24fps
                sampleRate: 48000
            ),
            at: .fps24,
            by: .wrapping
        )
        
        #expect(tc.components == Timecode.Components(h: 1))
    }
    
    @Test
    func timecode_init_Samples_RawValues() async {
        let tc = Timecode(
            .samples(
                (4_147_200_000 * 2) + 172_800_000, // 2 days + 1 hour @ 24fps
                sampleRate: 48000
            ),
            at: .fps24,
            by: .allowingInvalid
        )
        
        #expect(tc.components == Timecode.Components(d: 2, h: 1))
    }
    
    @Test
    func timecode_init_Samples_RawValues_Negative() async {
        let tc = Timecode(
            .samples(
                -((4_147_200_000 * 2) + 172_800_000), // 2 days + 1 hour @ 24fps
                sampleRate: 48000
            ),
            at: .fps24,
            by: .allowingInvalid
        )
        
        // Negates only the largest non-zero component if input is negative
        #expect(tc.components == Timecode.Components(d: -2, h: 1))
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_samplesGetSet_48KHz(frameRate: TimecodeFrameRate) async throws {
        // pre-computed constants
        
        // confirmed correct in PT and Cubase
        let samplesIn1DayTC_ShrunkFrameRates = 4_151_347_200.0
        let samplesIn1DayTC_BaseFrameRates = 4_147_200_000.0
        let samplesIn1DayTC_DropFrameRates = 4_147_195_853.0
        let samplesIn1DayTC_30DF = 4_143_052_800.0
        
        // allow for the over-estimate padding value that gets added in the TC->samples method
        let tolerance = 0.001
        
        // MARK: samples as Double
        func validate(
            using samplesIn1DayTC: Double,
            sRate: Int,
            fRate: TimecodeFrameRate,
            roundedForDropFrame: Bool
        ) throws {
            var tc = Timecode(.zero, at: fRate, limit: .max100Days)
            
            // get
            try tc.set(.components(d: 1))
            var sv = tc.samplesDoubleValue(sampleRate: sRate)
            if roundedForDropFrame {
                // add rounding for real drop rates (ie: 29.97d, not 30d);
                // DAWs seem to round using standard rounding rules (?)
                sv.round()
            }
            #expect(sv.isApproximatelyEqual(to: samplesIn1DayTC, absoluteTolerance: tolerance))
            
            // set
            try tc.set(.samples(samplesIn1DayTC, sampleRate: sRate))
            #expect(tc.components == Timecode.Components(d: 1))
        }
        
        // MARK: samples as Int
        func validate(
            using samplesIn1DayTC: Int,
            sRate: Int,
            fRate: TimecodeFrameRate
        ) throws {
            var tc = Timecode(.zero, at: fRate, limit: .max100Days)
            
            // get
            try tc.set(.components(d: 1))
            #expect(tc.samplesValue(sampleRate: sRate) == samplesIn1DayTC)
            
            // set
            try tc.set(.samples(samplesIn1DayTC, sampleRate: sRate))
            #expect(tc.components == Timecode.Components(d: 1))
        }
        
        // 48KHz ___________________________________
        
        let sRate = 48000
        
        var samplesIn1DayTCDouble = 0.0
        var samplesIn1DayTCInt = 0
        var roundedForDropFrame = false
        
        switch frameRate {
        case .fps23_976,
                .fps24_98,
                .fps29_97,
                .fps47_952,
                .fps59_94,
                .fps95_904,
                .fps119_88:
            
            samplesIn1DayTCDouble = samplesIn1DayTC_ShrunkFrameRates
            samplesIn1DayTCInt = Int(samplesIn1DayTCDouble)
            roundedForDropFrame = false
            
        case .fps24,
                .fps25,
                .fps30,
                .fps48,
                .fps50,
                .fps60,
                .fps90,
                .fps96,
                .fps100,
                .fps120:
            
            samplesIn1DayTCDouble = samplesIn1DayTC_BaseFrameRates
            samplesIn1DayTCInt = Int(samplesIn1DayTCDouble)
            roundedForDropFrame = false
            
        case .fps29_97d,
                .fps59_94d,
                .fps119_88d:
            
            // Cubase:
            // - reports 4147195853 @ 1 day
            // - there may be rounding happening in Cubase
            // Pro Tools:
            // - reports 2073597926 @ 12 hours
            // - double this would technically be 4147195854 but Cubase shows 1 frame less
            
            samplesIn1DayTCDouble = samplesIn1DayTC_DropFrameRates
            samplesIn1DayTCInt = Int(samplesIn1DayTCDouble)
            roundedForDropFrame = true // DAWs seem to using standard rounding for DF (?)
            
        case .fps30d,
                .fps60d,
                .fps120d:
            
            samplesIn1DayTCDouble = samplesIn1DayTC_30DF
            samplesIn1DayTCInt = Int(samplesIn1DayTCDouble)
            roundedForDropFrame = false
        }
        
        // int
        try validate(
            using: samplesIn1DayTCInt,
            sRate: sRate,
            fRate: frameRate
        )
        
        // double
        try validate(
            using: samplesIn1DayTCDouble,
            sRate: sRate,
            fRate: frameRate,
            roundedForDropFrame: roundedForDropFrame
        )
    }
    
    @Test
    func timecode_Samples_SubFrames() async throws {
        // ensure subframes are calculated correctly
        
        // test for precision and rounding issues by iterating every subframe
        // for each frame rate just below the timecode upper limit
        
        let logErrors = true
        
        let subFramesBase: Timecode.SubFramesBase = .max80SubFrames
        
        var frameRatesWithSetTimecodeErrors: Set<TimecodeFrameRate> = []
        var frameRatesWithSetTimecodeErrorsCount = 0
        var frameRatesWithMismatchingComponents: Set<TimecodeFrameRate> = []
        var frameRatesWithMismatchingComponentsCount = 0
        
        for subFrame in 0 ..< subFramesBase.rawValue {
            let tcc = Timecode.Components(d: 99, h: 23, sf: subFrame)
            
            for item in TimecodeFrameRate.allCases {
                var tc = try Timecode(
                    .components(tcc),
                    at: item,
                    base: subFramesBase,
                    limit: .max100Days
                )
                
                let sRate = 48000
                
                // timecode to samples
                
                let samples = tc.samplesDoubleValue(sampleRate: sRate)
                
                // samples to timecode
                
                if (try? tc.set(.samples(
                    samples,
                    sampleRate: sRate
                ))) == nil {
                    frameRatesWithSetTimecodeErrors.insert(item)
                    frameRatesWithSetTimecodeErrorsCount += 1
                    if logErrors {
                        let fr = "\(item)".padding(toLength: 8, withPad: " ", startingAt: 0)
                        print("set(.samples(:sampleRate:)) failed @ \(fr)")
                    }
                }
                
                if tc.components != tcc {
                    frameRatesWithMismatchingComponents.insert(item)
                    frameRatesWithMismatchingComponentsCount += 1
                    if logErrors {
                        let fr = "\(item)".padding(toLength: 8, withPad: " ", startingAt: 0)
                        print(
                            "Timecode.Components match failed @ \(fr) - origin \(tcc) to \(samples) samples converted to \(tc.components)"
                        )
                    }
                }
            }
        }
        
        if !frameRatesWithSetTimecodeErrors.isEmpty {
            Issue.record(
                "These frame rates had \(frameRatesWithSetTimecodeErrorsCount) errors setting timecode from samples: \(frameRatesWithSetTimecodeErrors.sorted())"
            )
        }
        
        if !frameRatesWithMismatchingComponents.isEmpty {
            Issue.record(
                "These frame rates had \(frameRatesWithMismatchingComponentsCount) errors with mismatching timecode components after converting samples: \(frameRatesWithSetTimecodeErrors.sorted())"
            )
        }
    }
    
    @Test
    func edgeCases() async throws {
        // test for really large values
        
        #expect(
            Timecode(
                .components(
                    d: 1234567891234564567,
                    h: 1234567891234564567,
                    m: 1234567891234564567,
                    s: 1234567891234564567,
                    f: 1234567891234564567,
                    sf: 1234567891234564567
                ),
                at: .fps24, by: .allowingInvalid
            )
            .samplesValue(sampleRate: 48000)
            == 0 // failsafe value
        )
    }
}
