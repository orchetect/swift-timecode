//
//  Timecode Rational Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

@testable import SwiftTimecodeCore
import Testing

@Suite struct Timecode_Source_Rational_Tests {
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_init_Rational_Exactly(frameRate: TimecodeFrameRate) async throws {
        let tc = try Timecode(
            .rational(Fraction(10, 1)),
            at: frameRate
        )
        
        // don't imperatively check each result, just make sure that a value was set;
        // setter logic is unit-tested elsewhere, we just want to check the Timecode.init interface here.
        #expect(tc.seconds != 0)
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_init_Rational(frameRate: TimecodeFrameRate) async throws {
        // these rational fractions and timecodes are taken from actual FCP XML files as known truth
        
        switch frameRate {
        case .fps23_976:
            #expect(
                try Timecode(.rational(Fraction(335335, 24000)), at: frameRate).components
                    == Timecode.Components(h: 00, m: 00, s: 13, f: 23)
            )
        case .fps24:
            #expect(
                try Timecode(.rational(Fraction(167500, 12000)), at: frameRate).components
                    == Timecode.Components(h: 00, m: 00, s: 13, f: 23)
            )
        case .fps24_98:
            break // TODO: finish this
        case .fps25: // same fraction is found in FCP XML for 25p and 25i video rates
            #expect(
                try Timecode(.rational(Fraction(34900, 2500)), at: frameRate).components
                    == Timecode.Components(h: 00, m: 00, s: 13, f: 24)
            )
        case .fps29_97: // same fraction is found in FCP XML for 29.97p and 29.97i video rates
            #expect(
                try Timecode(.rational(Fraction(838838, 60000)), at: frameRate).components
                    == Timecode.Components(h: 00, m: 00, s: 13, f: 29)
            )
            #expect(
                try Timecode(.rational(Fraction(1920919, 30000)), at: frameRate).components
                    == Timecode.Components(h: 00, m: 01, s: 03, f: 29)
            )
        case .fps29_97d:
            #expect(
                try Timecode(.rational(Fraction(419419, 30000)), at: frameRate).components
                    == Timecode.Components(h: 00, m: 00, s: 13, f: 29)
            )
            #expect(
                try Timecode(.rational(Fraction(1918917, 30000)), at: frameRate).components
                    == Timecode.Components(h: 00, m: 01, s: 03, f: 29)
            )
        case .fps30:
            #expect(
                try Timecode(.rational(Fraction(83800, 6000)), at: frameRate).components
                    == Timecode.Components(h: 00, m: 00, s: 13, f: 29)
            )
        case .fps30d:
            break // TODO: finish this
        case .fps47_952:
            break // TODO: finish this
        case .fps48:
            break // TODO: finish this
        case .fps50:
            #expect(
                try Timecode(.rational(Fraction(69900, 5000)), at: frameRate).components
                    == Timecode.Components(h: 00, m: 00, s: 13, f: 49)
            )
        case .fps59_94:
            #expect(
                try Timecode(.rational(Fraction(839839, 60000)), at: frameRate).components
                    == Timecode.Components(h: 00, m: 00, s: 13, f: 59)
            )
        case .fps59_94d:
            break // TODO: finish this
        case .fps60:
            #expect(
                try Timecode(.rational(Fraction(83900, 6000)), at: frameRate).components
                    == Timecode.Components(h: 00, m: 00, s: 13, f: 59)
            )
        case .fps60d:
            break // TODO: finish this
        case .fps90:
            #expect(
                try Timecode(.rational(Fraction(90000, 9000)), at: frameRate).components
                    == Timecode.Components(h: 00, m: 00, s: 10, f: 00)
            )
        case .fps95_904:
            break // TODO: finish this
        case .fps96:
            break // TODO: finish this
        case .fps100:
            break // TODO: finish this
        case .fps119_88:
            break // TODO: finish this
        case .fps119_88d:
            break // TODO: finish this
        case .fps120:
            break // TODO: finish this
        case .fps120d:
            break // TODO: finish this
        }
    }
    
    @Test
    func timecode_init_Rational_Clamping() async {
        let tc = Timecode(
            .rational(Fraction(86400 + 3600, 1)), // 25 hours @ 24fps
            at: .fps24,
            by: .clamping
        )
        
        #expect(
            tc.components
                == Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    @Test
    func timecode_init_Rational_Clamping_Negative() async {
        let tc = Timecode(
            .rational(Fraction(-2, 1)),
            at: .fps24,
            by: .clamping
        )
        
        #expect(
            tc.components
                == Timecode.Components(h: 00, m: 00, s: 00, f: 00)
        )
    }
    
    @Test
    func timecode_init_Rational_Wrapping() async {
        let tc = Timecode(
            .rational(Fraction(86400 + 3600, 1)), // 25 hours @ 24fps
            at: .fps24,
            by: .wrapping
        )
        
        #expect(
            tc.components
                == Timecode.Components(d: 00, h: 01, m: 00, s: 00, f: 00, sf: 00)
        )
    }
    
    @Test
    func timecode_init_Rational_Wrapping_Negative() async {
        let tc = Timecode(
            .rational(Fraction(-2, 1)),
            at: .fps24,
            by: .wrapping
        )
        
        #expect(
            tc.components
                == Timecode.Components(d: 00, h: 23, m: 59, s: 58, f: 00, sf: 00)
        )
    }
    
    @Test
    func timecode_init_Rational_RawValues() async {
        let tc = Timecode(
            .rational(Fraction((86400 * 2) + 3600, 1)), // 2 days + 1 hour @ 24fps
            at: .fps24,
            by: .allowingInvalid
        )
        
        #expect(
            tc.components
                == Timecode.Components(d: 02, h: 01, m: 00, s: 00, f: 00, sf: 00)
        )
    }
    
    @Test
    func timecode_init_Rational_RawValues_Negative() async {
        let tc = Timecode(
            .rational(Fraction(-(3600 + 60 + 5), 1)),
            at: .fps24,
            by: .allowingInvalid
        )
        
        // Negates only the largest non-zero component if input is negative
        #expect(
            tc.components
                == Timecode.Components(d: 00, h: -01, m: 01, s: 05, f: 00, sf: 00)
        )
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_rationalValue(frameRate: TimecodeFrameRate) async throws {
        // test a small range of timecodes at each frame rate
        // and ensure the fraction can re-form the same timecode
        
        let s = try Timecode(.components(m: 8, f: 20), at: frameRate)
        let e = try Timecode(.components(m: 10, f: 5), at: frameRate)
        
        for tc in s ... e {
            let f = tc.rationalValue
            let reformedTC = try Timecode(.rational(f), at: frameRate)
            #expect(tc == reformedTC)
        }
    }
    
    @Test
    func timecode_RationalValue_SpotCheck() async throws {
        let tc = try Timecode(.components(h: 00, m: 00, s: 13, f: 29), at: .fps29_97d)
        #expect(tc.rationalValue.numerator == 419419)
        #expect(tc.rationalValue.denominator == 30000)
    }
    
    @Test
    func timecode_RationalValue_Subframes() async throws {
        let tc = try Timecode(
            .components(h: 00, m: 00, s: 01, f: 11, sf: 56),
            at: .fps25,
            base: .max80SubFrames
        )
        #expect(tc.rationalValue == Fraction(367, 250))
    }
    
    @Test
    func timecode_RationalSubframes() async throws {
        // 00:00:01:11.56 @ 25i fps, 80sf base
        // this fraction is actually a little past 56 subframes
        // because it was from FCPXML where it was not on an exact subframe
        // FYI: when we convert it back to a fraction from timecode,
        // the fraction ends up 367/250
        let frac = Fraction(11011, 7500)
        let tc = try Timecode(.rational(frac), at: .fps25, base: .max80SubFrames)
        #expect(tc.components == Timecode.Components(h: 00, m: 00, s: 01, f: 11, sf: 56))
        #expect(tc.rationalValue == Fraction(367, 250))
    }
    
    @Test
    func timecode_FrameCountOfRational() async throws {
        // 00:00:01:11.56 @ 25i fps, 80sf base
        // this fraction is actually a little past 56 subframes
        // because it was from FCPXML where it was not on an exact subframe
        // FYI: when we convert it back to a fraction from timecode,
        // the fraction ends up 367/250
        let frac = Fraction(11011, 7500)
        let tc = try Timecode(.rational(frac), at: .fps25, base: .max80SubFrames)
        let int = tc.frameCount(of: frac)
        #expect(int == 36)
    }
    
    @Test
    func timecode_FloatingFrameCountOfRational() async throws {
        // 00:00:01:11.56 @ 25i fps, 80sf base
        // this fraction is actually a little past 56 subframes
        // because it was from FCPXML where it was not on an exact subframe
        // FYI: when we convert it back to a fraction from timecode,
        // the fraction ends up 367/250
        let frac = Fraction(11011, 7500)
        let tc = try Timecode(.rational(frac), at: .fps25, base: .max80SubFrames)
        let float = tc.floatingFrameCount(of: frac)
        #expect(float == 36.70333333333333)
    }
}
