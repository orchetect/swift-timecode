//
//  Timecode init Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

@testable import SwiftTimecodeCore
import Testing

@Suite struct Timecode_init_Tests {
    // MARK: - Basic
    
    @Test
    func timecode_init_Defaults() async {
        // essential inits
        
        // defaults
        
        let tc = Timecode(.zero, at: .fps24)
        #expect(tc.frameRate == .fps24)
        #expect(tc.upperLimit == .max24Hours)
        #expect(tc.frameCount.subFrameCount == 0)
        #expect(tc.components == Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0))
        #expect(tc.stringValue() == "00:00:00:00")
    }
    
    // MARK: - Misc
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func timecode_init_All_DisplaySubFrames(frameRate: TimecodeFrameRate) async throws {
        let tc = try Timecode(
            .string("00:00:00:00"),
            at: frameRate,
            base: .max100SubFrames,
            limit: .max24Hours
        )
        
        var frm: String
        switch frameRate.numberOfDigits {
        case 2: frm = "00"
        case 3: frm = "000"
        default:
            Issue.record("Unhandled number of frames digits.")
            return
        }
        
        let frSep = frameRate.isDrop ? ";" : ":"
        
        #expect(tc.stringValue(format: [.showSubFrames]) == "00:00:00\(frSep)\(frm).00")
    }
}
