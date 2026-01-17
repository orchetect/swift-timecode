//
//  Timecode String Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore // do NOT import as @testable in this file
import Testing

@Suite struct Timecode_Source_String_Tests {
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_init_String_zero(frameRate: TimecodeFrameRate) async throws {
            let tc = try Timecode(
                .string("00:00:00:00"),
                at: frameRate
            )
            
            #expect(tc.components == .zero)
        }
        
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_init_String_nonZero(frameRate: TimecodeFrameRate) async throws {
        let tc = try Timecode(
            .string("01:02:03:04"),
            at: frameRate
        )
        
        #expect(tc.components == .init(h: 01, m: 02, s: 03, f: 04))
    }
    
    @Test
    func timecode_init_String_Clamping() async throws {
        let tc = try Timecode(
            .string("25:00:00:00"),
            at: .fps24,
            by: .clamping
        )
        
        #expect(
            tc.components
                == Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    @Test
    func timecode_init_String_ClampingEach() async throws {
        let tc = try Timecode(
            .string("25:00:00:00"),
            at: .fps24,
            by: .clampingComponents
        )
        
        #expect(tc.components == Timecode.Components(h: 23, m: 00, s: 00, f: 00))
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_init_String_Wrapping(frameRate: TimecodeFrameRate) async throws {
        let tc = try Timecode(
            .string("25:00:00:00"),
            at: frameRate,
            by: .wrapping
        )
        
        #expect(tc.components == .init(h: 01))
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_init_String_RawValues(frameRate: TimecodeFrameRate) async throws {
        let tc = try Timecode(
            .string("99 99:99:99:99.99"),
            at: frameRate,
            by: .allowingInvalid
        )
        
        #expect(tc.components == .init(d: 99, h: 99, m: 99, s: 99, f: 99, sf: 99))
    }
    
    @Test
    func stringValue_GetSet_Basic() async throws {
        // basic getter tests
        
        var tc = Timecode(.zero, at: .fps23_976)
        
        try tc.set(.string("01:05:20:14"))
        #expect(tc.stringValue() == "01:05:20:14")
        
        #expect(throws: (any Error).self) { try tc.set(.string("50:05:20:14")) }
        #expect(tc.stringValue() == "01:05:20:14") // no change
        
        try tc.set(.string("50:05:20:14"), by: .clampingComponents)
        #expect(tc.stringValue() == "23:05:20:14")
    }
    
    @Test(arguments: TimecodeFrameRate.allNonDrop)
    func stringValue_Get_Formatting_Basic_24HourLimit_NonDrop(frameRate: TimecodeFrameRate) async throws {
        // basic string formatting - ie: HH:MM:SS:FF
        // using known valid timecode components; not testing for invalid values here
        
        let sv = try Timecode(.components(h: 1, m: 02, s: 03, f: 04), at: frameRate)
            .stringValue()
        
        let t = frameRate.numberOfDigits == 2 ? "" : "0"
        
        #expect(sv == "01:02:03:\(t)04")
    }
    
    @Test(arguments: TimecodeFrameRate.allDrop)
    func stringValue_Get_Formatting_Basic_24HourLimit_Drop(frameRate: TimecodeFrameRate) async throws {
        // basic string formatting - ie: HH:MM:SS:FF
        // using known valid timecode components; not testing for invalid values here
        
        let sv = try Timecode(.components(h: 1, m: 02, s: 03, f: 04), at: frameRate)
            .stringValue()
        
        let t = frameRate.numberOfDigits == 2 ? "" : "0"
        
        #expect(sv == "01:02:03;\(t)04")
    }
    
    @Test(arguments: TimecodeFrameRate.allNonDrop)
    func stringValue_Get_Formatting_Basic_100DaysLimit_NonDrop(frameRate: TimecodeFrameRate) async throws {
        // basic string formatting - ie: HH:MM:SS:FF
        // using known valid timecode components; not testing for invalid values here
        
        let sv = try Timecode(.components(h: 1, m: 02, s: 03, f: 04), at: frameRate, limit: .max100Days)
            .stringValue()
        
        let t = frameRate.numberOfDigits == 2 ? "" : "0"
        
        #expect(sv == "01:02:03:\(t)04")  // omits days since they are 0
    }
    
    @Test(arguments: TimecodeFrameRate.allDrop)
    func stringValue_Get_Formatting_Basic_100DaysLimit_Drop(frameRate: TimecodeFrameRate) async throws {
        // basic string formatting - ie: HH:MM:SS:FF
        // using known valid timecode components; not testing for invalid values here
        
        let sv = try Timecode(.components(h: 1, m: 02, s: 03, f: 04), at: frameRate, limit: .max100Days)
            .stringValue()
        
        let t = frameRate.numberOfDigits == 2 ? "" : "0"
        
        #expect(sv == "01:02:03;\(t)04")  // omits days since they are 0
    }
    
    @Test(arguments: TimecodeFrameRate.allNonDrop)
    func stringValue_Get_Formatting_WithDays_24HoursLimit_NonDrop(frameRate: TimecodeFrameRate) async throws {
        // string formatting with days - ie: "D HH:MM:SS:FF"
        // using known valid timecode components; not testing for invalid values here
        
        var tc = try Timecode(.components(h: 1, m: 02, s: 03, f: 04), at: frameRate)
        tc.days = 2 // set days after init since init fails if we pass days
        
        let t = frameRate.numberOfDigits == 2 ? "" : "0"
        
        // still produces days since we have not clamped it yet
        var sv = tc.stringValue()
        #expect(sv == "2 01:02:03:\(t)04")
        
        // now omits days since our limit is 24hr and clamped
        tc.clampComponents()
        sv = tc.stringValue()
        #expect(sv == "01:02:03:\(t)04")
    }
    
    @Test(arguments: TimecodeFrameRate.allDrop)
    func stringValue_Get_Formatting_WithDays_24HoursLimit_Drop(frameRate: TimecodeFrameRate) async throws {
        // string formatting with days - ie: "D HH:MM:SS:FF"
        // using known valid timecode components; not testing for invalid values here
        
        var tc = try Timecode(.components(h: 1, m: 02, s: 03, f: 04), at: frameRate)
        tc.days = 2 // set days after init since init fails if we pass days
        
        let t = frameRate.numberOfDigits == 2 ? "" : "0"
        
        // still produces days since we have not clamped it yet
        var sv = tc.stringValue()
        #expect(sv == "2 01:02:03;\(t)04")
        
        // now omits days since our limit is 24hr and clamped
        tc.clampComponents()
        sv = tc.stringValue()
        #expect(sv == "01:02:03;\(t)04")
    }
    
    @Test(arguments: TimecodeFrameRate.allNonDrop)
    func stringValue_Get_Formatting_WithDays_100DaysLimit_NonDrop(frameRate: TimecodeFrameRate) async throws {
        // string formatting with days - ie: "D HH:MM:SS:FF"
        // using known valid timecode components; not testing for invalid values here
        
        let sv = try Timecode(.components(d: 2, h: 1, m: 02, s: 03, f: 04), at: frameRate, limit: .max100Days)
            .stringValue()
        
        let t = frameRate.numberOfDigits == 2 ? "" : "0"
        
        #expect(sv == "2 01:02:03:\(t)04")
    }
    
    @Test(arguments: TimecodeFrameRate.allDrop)
    func stringValue_Get_Formatting_WithDays_100DaysLimit_Drop(frameRate: TimecodeFrameRate) async throws {
        // string formatting with days - ie: "D HH:MM:SS:FF"
        // using known valid timecode components; not testing for invalid values here
        
        let sv = try Timecode(.components(d: 2, h: 1, m: 02, s: 03, f: 04), at: frameRate, limit: .max100Days)
            .stringValue()
        
        let t = frameRate.numberOfDigits == 2 ? "" : "0"
        
        #expect(sv == "2 01:02:03;\(t)04")
    }
    
    @Test(arguments: TimecodeFrameRate.allNonDrop)
    func stringValue_Get_Formatting_WithSubframes_24HoursLimit_NonDrop(frameRate: TimecodeFrameRate) async throws {
        // string formatting with subframes - ie: "HH:MM:SS:FF.sf" (or "D HH:MM:SS:FF.sf" in case of 100 days limit)
        // using known valid timecode components; not testing for invalid values here
        
        var tc = try Timecode(.components(h: 1, m: 02, s: 03, f: 04, sf: 12), at: frameRate)
        tc.days = 2 // set days after init since init @ .max24Hours limit fails if we pass days
        
        let t = frameRate.numberOfDigits == 2 ? "" : "0"
        
        // still produces days since we have not clamped it yet
        var sv = tc.stringValue(format: [.showSubFrames])
        #expect(sv == "2 01:02:03:\(t)04.12")
        
        // now omits days since our limit is 24hr and clamped
        tc.clampComponents()
        sv = tc.stringValue(format: [.showSubFrames])
        #expect(sv == "01:02:03:\(t)04.12")
    }
    
    @Test(arguments: TimecodeFrameRate.allDrop)
    func stringValue_Get_Formatting_WithSubframes_24HoursLimit_Drop(frameRate: TimecodeFrameRate) async throws {
        // string formatting with subframes - ie: "HH:MM:SS:FF.sf" (or "D HH:MM:SS:FF.sf" in case of 100 days limit)
        // using known valid timecode components; not testing for invalid values here
        
        var tc = try Timecode(.components(h: 1, m: 02, s: 03, f: 04, sf: 12), at: frameRate)
        tc.days = 2 // set days after init since init @ .max24Hours limit fails if we pass days
        
        let t = frameRate.numberOfDigits == 2 ? "" : "0"
        
        // still produces days since we have not clamped it yet
        var sv = tc.stringValue(format: [.showSubFrames])
        #expect(sv == "2 01:02:03;\(t)04.12")
        
        // now omits days since our limit is 24hr and clamped
        tc.clampComponents()
        sv = tc.stringValue(format: [.showSubFrames])
        #expect(sv == "01:02:03;\(t)04.12")
    }
    
    @Test(arguments: TimecodeFrameRate.allNonDrop)
    func stringValue_Get_Formatting_WithSubframes_100DaysLimit_NonDrop(frameRate: TimecodeFrameRate) async throws {
        // string formatting with subframes - ie: "HH:MM:SS:FF.sf" (or "D HH:MM:SS:FF.sf" in case of 100 days limit)
        // using known valid timecode components; not testing for invalid values here
        
        let tc = try Timecode(.components(d: 2, h: 1, m: 02, s: 03, f: 04, sf: 12), at: frameRate, limit: .max100Days)
        
        let t = frameRate.numberOfDigits == 2 ? "" : "0"
        
        let sv = tc.stringValue(format: [.showSubFrames])
        #expect(sv == "2 01:02:03:\(t)04.12")
    }
    
    @Test(arguments: TimecodeFrameRate.allDrop)
    func stringValue_Get_Formatting_WithSubframes_100DaysLimit_Drop(frameRate: TimecodeFrameRate) async throws {
        // string formatting with subframes - ie: "HH:MM:SS:FF.sf" (or "D HH:MM:SS:FF.sf" in case of 100 days limit)
        // using known valid timecode components; not testing for invalid values here
        
        let tc = try Timecode(.components(d: 2, h: 1, m: 02, s: 03, f: 04, sf: 12), at: frameRate, limit: .max100Days)
        
        let t = frameRate.numberOfDigits == 2 ? "" : "0"
        
        let sv = tc.stringValue(format: [.showSubFrames])
        #expect(sv == "2 01:02:03;\(t)04.12")
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
                at: .fps24,
                by: .allowingInvalid
            )
            .stringValue(format: [.showSubFrames])
            == "1234567891234564567 1234567891234564567:1234567891234564567:1234567891234564567:1234567891234564567.1234567891234564567"
        )
    }
    
    @Test
    func stringValueVerbose() async throws {
        var tc = Timecode(.zero, at: .fps23_976)
        
        try tc.set(.string("01:05:20:14"))
        #expect(tc.stringValueVerbose == "01:05:20:14.00 @ 23.976 fps")
        
        try tc.set(.string("02:07:08:10.20"))
        #expect(tc.stringValueVerbose == "02:07:08:10.20 @ 23.976 fps")
    }
}
