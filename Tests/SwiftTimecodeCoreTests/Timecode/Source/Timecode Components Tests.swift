//
//  Timecode Components Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore // do NOT import as @testable in this file
import Testing

@Suite struct Timecode_Source_Components_Tests {
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_init_Components_Exactly_Zero(frameRate: TimecodeFrameRate) async throws {
        let tc = try Timecode(
            .components(d: 0, h: 0, m: 0, s: 0, f: 0),
            at: frameRate
        )
        
        #expect(tc.components == .zero)
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_init_Components_Exactly(frameRate: TimecodeFrameRate) async throws {
        let tc = try Timecode(
            .components(d: 0, h: 1, m: 2, s: 3, f: 4),
            at: frameRate
        )
        
        #expect(tc.components == Timecode.Components(d: 0, h: 1, m: 2, s: 3, f: 4))
    }

    @Test
    func timecode_init_Components_Clamping() async {
        let tc = Timecode(
            .components(h: 25),
            at: .fps24,
            by: .clamping
        )

        #expect(
            tc.components
                == Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }

    @Test
    func timecode_init_Components_ClampingEach() async {
        let tc = Timecode(
            .components(h: 25),
            at: .fps24,
            by: .clampingComponents
        )

        #expect(
            tc.components
                == Timecode.Components(h: 23, m: 00, s: 00, f: 00)
        )
    }

    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_init_Components_Wrapping(frameRate: TimecodeFrameRate) async {
        let tc = Timecode(
            .components(h: 25),
            at: frameRate,
            by: .wrapping
        )
        
        #expect(tc.components == Timecode.Components(h: 1))
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_init_Components_RawValues(frameRate: TimecodeFrameRate) async {
        let tc = Timecode(
            .components(d: 99, h: 99, m: 99, s: 99, f: 99, sf: 99),
            at: frameRate,
            by: .allowingInvalid
        )
        
        #expect(tc.components == Timecode.Components(d: 99, h: 99, m: 99, s: 99, f: 99, sf: 99))
    }

    @Test
    func timecode_components_24Hours() async {
        // default

        var tc = Timecode(.zero, at: .fps30)

        #expect(tc.components == Timecode.Components.zero)

        // setter

        tc.components = Timecode.Components(h: 1, m: 2, s: 3, f: 4, sf: 5)

        #expect(tc.components == Timecode.Components(h: 1, m: 2, s: 3, f: 4, sf: 5))
    }

    @Test
    func timecode_components_100Days() async {
        // default

        var tc = Timecode(.zero, at: .fps30, limit: .max100Days)

        #expect(tc.components == Timecode.Components.zero)

        // setter

        tc.components = Timecode.Components(d: 5, h: 1, m: 2, s: 3, f: 4, sf: 5)

        #expect(tc.components == Timecode.Components(d: 5, h: 1, m: 2, s: 3, f: 4, sf: 5))
    }

    @Test
    func setTimecodeExactly() throws {
        // this is not meant to test the underlying logic, simply that set() produces the intended outcome

        var tc = Timecode(.zero, at: .fps30)

        try tc.set(.components(h: 1, m: 2, s: 3, f: 4, sf: 5))

        #expect(tc.components == Timecode.Components(h: 1, m: 2, s: 3, f: 4, sf: 5))
    }

    @Test
    func setTimecodeClamping() async {
        // this is not meant to test the underlying logic, simply that set() produces the intended outcome

        var tc = Timecode(.zero, at: .fps30, base: .max80SubFrames)

        tc.set(.components(d: 1, h: 70, m: 70, s: 70, f: 70, sf: 500), by: .clamping)

        #expect(tc.components == Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: 29, sf: 79))
    }

    @Test
    func setTimecodeClampingEach() async {
        // this is not meant to test the underlying logic, simply that set() produces the intended outcome

        var tc = Timecode(.zero, at: .fps30, base: .max80SubFrames)

        tc.set(.components(h: 70, m: 00, s: 70, f: 00, sf: 500), by: .clampingComponents)

        #expect(tc.components == Timecode.Components(d: 0, h: 23, m: 00, s: 59, f: 00, sf: 79))
    }

    @Test
    func setTimecodeWrapping() async {
        // this is not meant to test the underlying logic, simply that set() produces the intended outcome

        var tc = Timecode(.zero, at: .fps30)

        tc.set(.components(f: -1), by: .wrapping)

        #expect(tc.components == Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: 29, sf: 00))
    }
}
