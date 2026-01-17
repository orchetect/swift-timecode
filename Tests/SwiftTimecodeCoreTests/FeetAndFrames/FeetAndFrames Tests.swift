//
//  FeetAndFrames Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import Testing

@Suite struct FeetAndFrames_Tests {
    @Test
    func initString() async throws {
        // expected formatting
        
        #expect(try FeetAndFrames("0+00").stringValue == "0+00")
        #expect(try FeetAndFrames("0+01").stringValue == "0+01")
        #expect(try FeetAndFrames("1+00").stringValue == "1+00")
        #expect(try FeetAndFrames("10+00").stringValue == "10+00")
        #expect(try FeetAndFrames("100+14").stringValue == "100+14")
        #expect(try FeetAndFrames("100+150").stringValue == "100+150")
        
        #expect(try FeetAndFrames("0+00.00").stringValueVerbose == "0+00.00")
        #expect(try FeetAndFrames("0+01.00").stringValueVerbose == "0+01.00")
        #expect(try FeetAndFrames("1+00.00").stringValueVerbose == "1+00.00")
        #expect(try FeetAndFrames("10+00.00").stringValueVerbose == "10+00.00")
        #expect(try FeetAndFrames("100+14.00").stringValueVerbose == "100+14.00")
        #expect(try FeetAndFrames("0+00.01").stringValueVerbose == "0+00.01")
        #expect(try FeetAndFrames("0+01.01").stringValueVerbose == "0+01.01")
        #expect(try FeetAndFrames("1+00.01").stringValueVerbose == "1+00.01")
        #expect(try FeetAndFrames("10+00.24").stringValueVerbose == "10+00.24")
        #expect(try FeetAndFrames("100+14.150").stringValueVerbose == "100+14.150")
        
        // loose formatting
        
        #expect(try FeetAndFrames("1+2").stringValue == "1+02")
        #expect(try FeetAndFrames("01+2").stringValue == "1+02")
        #expect(try FeetAndFrames("1+02").stringValue == "1+02")
        #expect(try FeetAndFrames("01+02").stringValue == "1+02")
        #expect(try FeetAndFrames("001+002").stringValue == "1+02")
        
        // edge cases
        
        #expect(throws: (any Error).self) { try FeetAndFrames("+") }
        #expect(throws: (any Error).self) { try FeetAndFrames("0+") }
        #expect(throws: (any Error).self) { try FeetAndFrames("+0") }
        #expect(throws: (any Error).self) { try FeetAndFrames("0++0") }
        #expect(throws: (any Error).self) { try FeetAndFrames("0++00") }
        #expect(throws: (any Error).self) { try FeetAndFrames("0+00.") }
        #expect(throws: (any Error).self) { try FeetAndFrames("0+.") }
        #expect(throws: (any Error).self) { try FeetAndFrames("0+.0") }
        #expect(throws: (any Error).self) { try FeetAndFrames("+.0") }
        #expect(throws: (any Error).self) { try FeetAndFrames("Z+ZZ") }
        #expect(throws: (any Error).self) { try FeetAndFrames("Z+ZZ.ZZ") }
        #expect(throws: (any Error).self) { try FeetAndFrames("1+ZZ") }
        #expect(throws: (any Error).self) { try FeetAndFrames("Z+02") }
        #expect(throws: (any Error).self) { try FeetAndFrames("1+ZZ.ZZ") }
        #expect(throws: (any Error).self) { try FeetAndFrames("Z+02.ZZ") }
    }
    
    @Test
    func stringValue() async {
        #expect(FeetAndFrames(feet: 0, frames: 0).stringValue == "0+00")
        #expect(FeetAndFrames(feet: 0, frames: 1).stringValue == "0+01")
        #expect(FeetAndFrames(feet: 1, frames: 0).stringValue == "1+00")
        #expect(FeetAndFrames(feet: 10, frames: 0).stringValue == "10+00")
        #expect(FeetAndFrames(feet: 100, frames: 14).stringValue == "100+14")
        
        // edge cases
        #expect(FeetAndFrames(feet: 100, frames: 150).stringValue == "100+150")
    }
    
    @Test
    func stringValueVerbose() async {
        #expect(FeetAndFrames(feet: 0, frames: 0).stringValueVerbose == "0+00.00")
        #expect(FeetAndFrames(feet: 0, frames: 1).stringValueVerbose == "0+01.00")
        #expect(FeetAndFrames(feet: 1, frames: 0).stringValueVerbose == "1+00.00")
        #expect(FeetAndFrames(feet: 10, frames: 0).stringValueVerbose == "10+00.00")
        #expect(FeetAndFrames(feet: 100, frames: 14).stringValueVerbose == "100+14.00")
        
        #expect(FeetAndFrames(feet: 0, frames: 0, subFrames: 1).stringValueVerbose == "0+00.01")
        #expect(FeetAndFrames(feet: 0, frames: 1, subFrames: 1).stringValueVerbose == "0+01.01")
        #expect(FeetAndFrames(feet: 1, frames: 0, subFrames: 1).stringValueVerbose == "1+00.01")
        #expect(FeetAndFrames(feet: 10, frames: 0, subFrames: 24).stringValueVerbose == "10+00.24")
        
        // edge cases
        #expect(FeetAndFrames(feet: 100, frames: 14, subFrames: 150).stringValueVerbose == "100+14.150")
    }
    
    @Test(arguments: TimecodeFrameRate.allCases)
    func frameCount(frameRate: TimecodeFrameRate) async throws {
        let tc10Hours = try Timecode(.components(h: 10), at: frameRate)
        let ff = tc10Hours.feetAndFramesValue
        #expect(ff.frameCount == tc10Hours.frameCount)
    }
}
