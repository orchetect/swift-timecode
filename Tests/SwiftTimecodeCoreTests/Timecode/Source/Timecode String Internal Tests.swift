//
//  Timecode String Internal Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

@testable import SwiftTimecodeCore
import Testing

@Suite struct Timecode_Source_String_Internal_Tests {
    @Test
    func stringDecode() async throws {
        // non-drop frame
        
        #expect(throws: (any Error).self) { try Timecode.decode(timecode: "") }
        #expect(throws: (any Error).self) { try Timecode.decode(timecode: "01564523") }
        #expect(
            try Timecode.decode(timecode: "0:0:0:0")
                == Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "0:00:00:00")
                == Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "00:00:00:00")
                == Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "1:56:45:23")
                == Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "01:56:45:23")
                == Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "3 01:56:45:23")
                == Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "12 01:56:45:23")
                == Timecode.Components(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "12:01:56:45:23")
                == Timecode.Components(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00)
        )
        
        // drop frame
        
        #expect(
            try Timecode.decode(timecode: "0:0:0;0")
                == Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "0:00:00;00")
                == Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "00:00:00;00")
                == Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "1:56:45;23")
                == Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        #expect(
            try Timecode.decode(timecode: "01:56:45;23")
                == Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        #expect(
            try Timecode.decode(timecode: "3 01:56:45;23")
                == Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        #expect(
            try Timecode.decode(timecode: "12 01:56:45;23")
                == Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        #expect(
            try Timecode.decode(timecode: "12:01:56:45;23")
                == Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        // all semicolons (such as from Adobe Premiere in its XMP format)
        
        #expect(
            try Timecode.decode(timecode: "0;0;0;0")
                == Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "0;00;00;00")
                == Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "00;00;00;00")
                == Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "1;56;45;23")
                == Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "01;56;45;23")
                == Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "3 01;56;45;23")
                == Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "12 01;56;45;23")
                == Timecode.Components(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "12;01;56;45;23")
                == Timecode.Components(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00)
        )
        
        // drop frame
        
        #expect(
            try Timecode.decode(timecode: "0:0:0;0")
                == Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "0:00:00;00")
                == Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "00:00:00;00")
                == Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        #expect(
            try Timecode.decode(timecode: "1:56:45;23")
                == Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        #expect(
            try Timecode.decode(timecode: "01:56:45;23")
                == Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        #expect(
            try Timecode.decode(timecode: "3 01:56:45;23")
                == Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        #expect(
            try Timecode.decode(timecode: "12 01:56:45;23")
                == Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        #expect(
            try Timecode.decode(timecode: "12:01:56:45;23")
                == Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        // all periods - not supporting this.
        
        #expect(throws: (any Error).self) { try Timecode.decode(timecode: "0.0.0.0") }
        #expect(throws: (any Error).self) { try Timecode.decode(timecode: "0.00.00.00") }
        #expect(throws: (any Error).self) { try Timecode.decode(timecode: "00.00.00.00") }
        #expect(throws: (any Error).self) { try Timecode.decode(timecode: "1.56.45.23") }
        #expect(throws: (any Error).self) { try Timecode.decode(timecode: "01.56.45.23") }
        #expect(throws: (any Error).self) { try Timecode.decode(timecode: "3 01.56.45.23") }
        #expect(throws: (any Error).self) { try Timecode.decode(timecode: "12.01.56.45.23") }
        #expect(throws: (any Error).self) { try Timecode.decode(timecode: "12.01.56.45.23") }
        
        // subframes
        
        #expect(
            try Timecode.decode(timecode: "0:00:00:00.05")
                == Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05)
        )
        
        #expect(
            try Timecode.decode(timecode: "00:00:00:00.05")
                == Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05)
        )
        
        #expect(
            try Timecode.decode(timecode: "1:56:45:23.05")
                == Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        #expect(
            try Timecode.decode(timecode: "01:56:45:23.05")
                == Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        #expect(
            try Timecode.decode(timecode: "3 01:56:45:23.05")
                == Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        #expect(
            try Timecode.decode(timecode: "12 01:56:45:23.05")
                == Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        #expect(
            try Timecode.decode(timecode: "12:01:56:45:23.05")
                == Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        // subframes
        // all semicolons (such as from Adobe Premiere in its XMP format)
        
        #expect(
            try Timecode.decode(timecode: "0;00;00;00.05")
                == Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05)
        )
        
        #expect(
            try Timecode.decode(timecode: "00;00;00;00.05")
                == Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05)
        )
        
        #expect(
            try Timecode.decode(timecode: "1;56;45;23.05")
                == Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        #expect(
            try Timecode.decode(timecode: "01;56;45;23.05")
                == Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        #expect(
            try Timecode.decode(timecode: "3 01;56;45;23.05")
                == Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        #expect(
            try Timecode.decode(timecode: "12 01;56;45;23.05")
                == Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        #expect(
            try Timecode.decode(timecode: "12;01;56;45;23.05")
                == Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
    }
    
    @Test
    func stringDecodeEdgeCases() async throws {
        // test for really large values
        
        // valid Int values
        #expect(
            try Timecode.decode(
                timecode: "1234567891234564567 1234567891234564567:1234567891234564567:1234567891234564567:1234567891234564567.1234567891234564567"
            )
            == Timecode.Components(
                d: 1234567891234564567,
                h: 1234567891234564567,
                m: 1234567891234564567,
                s: 1234567891234564567,
                f: 1234567891234564567,
                sf: 1234567891234564567
            )
        )
        
        // overflowing Int values should throw an error (and not crash)
        #expect(throws: Timecode.StringParseError.malformed) {
            let string = "12345678912345645678 12345678912345645678:12345678912345645678:12345678912345645678:12345678912345645678.12345678912345645678"
            _ = try Timecode.decode(timecode: string)
        }
    }
}
