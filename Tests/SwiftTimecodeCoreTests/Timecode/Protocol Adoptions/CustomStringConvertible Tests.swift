//
//  CustomStringConvertible Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import Testing

@Suite struct Timecode_CustomStringConvertible_Tests {
    @Test
    func customStringConvertibleA() async throws {
        let tc = try Timecode(
            .components(d: 1, h: 2, m: 3, s: 4, f: 5, sf: 6),
            at: .fps24,
            limit: .max100Days
        )
        
        #expect(tc.description == "1 02:03:04:05.06")
        #expect(tc.debugDescription == "Timecode<1 02:03:04:05.06 @ 24 fps>")
    }
    
    @Test
    func customStringConvertibleB() async throws {
        let tc = Timecode(
            .zero,
            at: .fps23_976,
            limit: .max100Days
        )
        
        #expect(tc.description == "00:00:00:00.00")
        #expect(tc.debugDescription == "Timecode<0 00:00:00:00.00 @ 23.976 fps>")
    }
    
    @Test
    func customStringConvertibleC() async throws {
        let tc = Timecode(
            .zero,
            at: .fps23_976,
            limit: .max24Hours
        )
        
        #expect(tc.description == "00:00:00:00.00")
        #expect(tc.debugDescription == "Timecode<00:00:00:00.00 @ 23.976 fps>")
    }
}
