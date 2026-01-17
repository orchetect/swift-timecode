//
//  Timecode Conversion Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import Testing

@Suite struct Timecode_Conversion_Tests {
    /// Baseline check: Ensure conversion produces identical output if frame rates are equal.
    @Test(arguments: TimecodeFrameRate.allCases)
    func converted_NewFrameRate(frameRate: TimecodeFrameRate) async throws {
        let tc = try Timecode(.components(h: 1), at: frameRate, base: .max100SubFrames)
        
        let convertedTC = try tc.converted(to: frameRate)
        
        #expect(tc == convertedTC)
    }
    
    /// Spot-check an example conversion.
    @Test
    func converted_NewFrameRate_spotCheck() async throws {
        let convertedTC = try Timecode(
            .components(h: 1),
            at: .fps23_976,
            base: .max100SubFrames
        )
        .converted(to: .fps30)
        
        #expect(convertedTC.frameRate == .fps30)
        #expect(convertedTC.subFramesBase == .max100SubFrames)
        #expect(convertedTC.components == Timecode.Components(h: 1, m: 00, s: 03, f: 18, sf: 00))
    }
    
    /// Spot-check an example conversion.
    @Test
    func converted_NewFrameRate_NewSubFramesBaseA() async throws {
        let convertedTC = try Timecode(
            .components(sf: 50),
            at: .fps30,
            base: .max100SubFrames
        )
        .converted(to: .fps60, base: .max80SubFrames)
        
        #expect(convertedTC.frameRate == .fps60)
        #expect(convertedTC.subFramesBase == .max80SubFrames)
        #expect(convertedTC.components == Timecode.Components(f: 1))
    }
    
    /// Spot-check an example conversion.
    @Test
    func converted_NewFrameRate_NewSubFramesBaseB() async throws {
        let convertedTC = try Timecode(
            .components(h: 1, sf: 40),
            at: .fps23_976,
            base: .max80SubFrames
        )
        .converted(to: .fps30, base: .max100SubFrames)
        
        #expect(convertedTC.frameRate == .fps30)
        #expect(convertedTC.subFramesBase == .max100SubFrames)
        #expect(convertedTC.components == Timecode.Components(h: 1, m: 00, s: 03, f: 18, sf: 62))
    }
    
    /// Baseline check: Ensure conversion produces identical output if frame rates are equal.
    @Test(arguments: TimecodeFrameRate.allCases)
    func converted_NewFrameRate_PreservingValues(frameRate: TimecodeFrameRate) async throws {
        let tc = try Timecode(.components(h: 1), at: frameRate)
        
        let convertedTC = try tc.converted(to: frameRate, preservingValues: true)
        
        #expect(tc == convertedTC)
    }
    
    /// Spot-check: Arbitrary non-zero timecode values that should be able to be preserved across all frame rates.
    @Test(arguments: TimecodeFrameRate.allCases)
    func converted_NewFrameRate_PreservingValues(sourceFrameRate: TimecodeFrameRate) async throws {
        for destinationFrameRate in TimecodeFrameRate.allCases {
            let convertedTC = try Timecode(
                .components(h: 2, m: 07, s: 24, f: 11),
                at: sourceFrameRate,
                base: .max100SubFrames
            )
                .converted(to: destinationFrameRate, preservingValues: true)
            
            #expect(convertedTC.frameRate == destinationFrameRate)
            #expect(convertedTC.components == Timecode.Components(h: 2, m: 07, s: 24, f: 11, sf: 00))
        }
    }
    
    /// Spot-check: frames value too large to preserve; convert timecode instead
    @Test func converted_NewFrameRate_PreservingValues_Conversion() async throws {
        let convertedTC = try Timecode(
            .components(h: 1, m: 0, s: 0, f: 96),
            at: .fps100,
            base: .max100SubFrames
        )
        .converted(to: .fps50, preservingValues: true)
            
        #expect(convertedTC.frameRate == .fps50)
        #expect(convertedTC.components == Timecode.Components(h: 1, m: 00, s: 00, f: 48, sf: 00))
    }
    
    @Test
    func transform() async throws {
        var tc = try Timecode(.components(m: 1), at: .fps24)
        
        let transformer = TimecodeTransformer(.offset(by: .positive(tc)))
        tc.transform(using: transformer)
        
        #expect(try tc == Timecode(.components(m: 2), at: .fps24))
    }
    
    @Test
    func transformed() async throws {
        let tc = try Timecode(.components(m: 1), at: .fps24)
        
        let transformer = TimecodeTransformer(.offset(by: .positive(tc)))
        let newTC = tc.transformed(using: transformer)
        
        #expect(try newTC == Timecode(.components(m: 2), at: .fps24))
    }
}
