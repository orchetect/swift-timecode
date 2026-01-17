//
//  Timecode Rounding Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import Testing

@Suite struct Timecode_Rounding_Tests {
    // MARK: - Rounding Up
    
    @Test
    func roundedUp_days() async throws {
        #expect(
            try Timecode(.zero, at: .fps24)
                .roundedUp(toNearest: .days)
                .components
            == Timecode.Components()
        )
        
        #expect(
            try Timecode(.components(sf: 1), at: .fps24, limit: .max100Days)
                .roundedUp(toNearest: .days)
                .components
            == Timecode.Components(d: 1)
        )
        
        #expect(
            try Timecode(.components(f: 1), at: .fps24, limit: .max100Days)
                .roundedUp(toNearest: .days)
                .components
            == Timecode.Components(d: 1)
        )
        
        #expect(
            try Timecode(.components(s: 1), at: .fps24, limit: .max100Days)
                .roundedUp(toNearest: .days)
                .components
            == Timecode.Components(d: 1)
        )
        
        #expect(
            try Timecode(.components(m: 1), at: .fps24, limit: .max100Days)
                .roundedUp(toNearest: .days)
                .components
            == Timecode.Components(d: 1)
        )
        
        #expect(
            try Timecode(.components(h: 1), at: .fps24, limit: .max100Days)
                .roundedUp(toNearest: .days)
                .components
            == Timecode.Components(d: 1)
        )
        
        #expect(
            try Timecode(.components(m: 1, s: 1, f: 1, sf: 1), at: .fps24, limit: .max100Days)
                .roundedUp(toNearest: .days)
                .components
            == Timecode.Components(d: 1)
        )
        
        #expect(
            try Timecode(.components(h: 1, m: 1, s: 1, f: 1, sf: 1), at: .fps24, limit: .max100Days)
                .roundedUp(toNearest: .days)
                .components
            == Timecode.Components(d: 1)
        )
        
        #expect(
            try Timecode(.components(d: 1, h: 0, m: 1, s: 1, f: 1, sf: 1), at: .fps24, limit: .max100Days)
                .roundedUp(toNearest: .days)
                .components
            == Timecode.Components(d: 2)
        )
    }
    
    @Test
    func roundedUp_hours() async throws {
        #expect(
            try Timecode(.zero, at: .fps24)
                .roundedUp(toNearest: .hours)
                .components
            == Timecode.Components()
        )
        
        #expect(
            try Timecode(.components(sf: 1), at: .fps24).roundedUp(toNearest: .hours)
                .components
            == Timecode.Components(h: 1)
        )
        
        #expect(
            try Timecode(.components(f: 1), at: .fps24).roundedUp(toNearest: .hours)
                .components
            == Timecode.Components(h: 1)
        )
        
        #expect(
            try Timecode(.components(s: 1), at: .fps24).roundedUp(toNearest: .hours)
                .components
            == Timecode.Components(h: 1)
        )
        
        #expect(
            try Timecode(.components(m: 1), at: .fps24).roundedUp(toNearest: .hours)
                .components
            == Timecode.Components(h: 1)
        )
        
        #expect(
            try Timecode(.components(h: 1), at: .fps24).roundedUp(toNearest: .hours)
                .components
            == Timecode.Components(h: 1)
        )
        
        #expect(
            try Timecode(.components(m: 1, s: 1, f: 1, sf: 1), at: .fps24).roundedUp(toNearest: .hours)
                .components
            == Timecode.Components(h: 1)
        )
        
        #expect(
            try Timecode(.components(d: 1, h: 0, m: 1, s: 1, f: 1, sf: 1), at: .fps24, limit: .max100Days)
                .roundedUp(toNearest: .hours)
                .components
            == Timecode.Components(d: 1, h: 1)
        )
    }
    
    @Test
    func roundedUp_minutes() async throws {
        #expect(
            try Timecode(.zero, at: .fps24)
                .roundedUp(toNearest: .minutes)
                .components
            == Timecode.Components()
        )
        
        #expect(
            try Timecode(.components(sf: 1), at: .fps24).roundedUp(toNearest: .minutes)
                .components
            == Timecode.Components(m: 1)
        )
        
        #expect(
            try Timecode(.components(f: 1), at: .fps24).roundedUp(toNearest: .minutes)
                .components
            == Timecode.Components(m: 1)
        )
        
        #expect(
            try Timecode(.components(f: 1, sf: 1), at: .fps24).roundedUp(toNearest: .minutes)
                .components
            == Timecode.Components(m: 1)
        )
        
        #expect(
            try Timecode(.components(s: 2), at: .fps24).roundedUp(toNearest: .minutes)
                .components
            == Timecode.Components(m: 1)
        )
        
        #expect(
            try Timecode(.components(s: 2, sf: 1), at: .fps24).roundedUp(toNearest: .minutes)
                .components
            == Timecode.Components(m: 1)
        )
        
        #expect(
            try Timecode(.components(s: 2, f: 1), at: .fps24).roundedUp(toNearest: .minutes)
                .components
            == Timecode.Components(m: 1)
        )
        
        #expect(
            try Timecode(.components(s: 2, f: 1, sf: 1), at: .fps24).roundedUp(toNearest: .minutes)
                .components
            == Timecode.Components(m: 1)
        )
        
        #expect(
            try Timecode(.components(m: 1), at: .fps24).roundedUp(toNearest: .minutes)
                .components
            == Timecode.Components(m: 1)
        )
        
        #expect(
            try Timecode(.components(m: 1, sf: 1), at: .fps24).roundedUp(toNearest: .minutes)
                .components
            == Timecode.Components(m: 2)
        )
        
        #expect(
            try Timecode(.components(m: 1, f: 1), at: .fps24).roundedUp(toNearest: .minutes)
                .components
            == Timecode.Components(m: 2)
        )
        
        #expect(
            try Timecode(.components(m: 1, s: 1), at: .fps24).roundedUp(toNearest: .minutes)
                .components
            == Timecode.Components(m: 2)
        )
        
        #expect(
            try Timecode(.components(h: 1), at: .fps24).roundedUp(toNearest: .minutes)
                .components
            == Timecode.Components(h: 1)
        )
        
        #expect(
            try Timecode(.components(h: 1, m: 1), at: .fps24).roundedUp(toNearest: .minutes)
                .components
            == Timecode.Components(h: 1, m: 1)
        )
        
        #expect(
            try Timecode(.components(h: 1, m: 1, f: 1), at: .fps24).roundedUp(toNearest: .minutes)
                .components
            == Timecode.Components(h: 1, m: 2)
        )
    }
    
    @Test
    func roundedUp_seconds() async throws {
        #expect(
            try Timecode(.zero, at: .fps24).roundedUp(toNearest: .seconds)
                .components
            == Timecode.Components()
        )
        
        #expect(
            try Timecode(.components(sf: 1), at: .fps24).roundedUp(toNearest: .seconds)
                .components
            == Timecode.Components(s: 1)
        )
        
        #expect(
            try Timecode(.components(f: 1), at: .fps24).roundedUp(toNearest: .seconds)
                .components
            == Timecode.Components(s: 1)
        )
        
        #expect(
            try Timecode(.components(f: 1, sf: 1), at: .fps24).roundedUp(toNearest: .seconds)
                .components
            == Timecode.Components(s: 1)
        )
        
        #expect(
            try Timecode(.components(s: 2), at: .fps24).roundedUp(toNearest: .seconds)
                .components
            == Timecode.Components(s: 2)
        )
        
        #expect(
            try Timecode(.components(s: 2, sf: 1), at: .fps24).roundedUp(toNearest: .seconds)
                .components
            == Timecode.Components(s: 3)
        )
        
        #expect(
            try Timecode(.components(s: 2, f: 1), at: .fps24).roundedUp(toNearest: .seconds)
                .components
            == Timecode.Components(s: 3)
        )
        
        #expect(
            try Timecode(.components(s: 2, f: 1, sf: 1), at: .fps24).roundedUp(toNearest: .seconds)
                .components
            == Timecode.Components(s: 3)
        )
    }
    
    @Test
    func roundedUp_frames() async throws {
        #expect(
            try Timecode(.zero, at: .fps24).roundedUp(toNearest: .frames)
                .components
            == Timecode.Components()
        )
        
        #expect(
            try Timecode(.components(sf: 1), at: .fps24).roundedUp(toNearest: .frames)
                .components
            == Timecode.Components(f: 1)
        )
        
        #expect(
            try Timecode(.components(f: 1), at: .fps24).roundedUp(toNearest: .frames)
                .components
            == Timecode.Components(f: 1)
        )
        
        #expect(
            try Timecode(.components(f: 1, sf: 1), at: .fps24).roundedUp(toNearest: .frames)
                .components
            == Timecode.Components(f: 2)
        )
    }
    
    @Test
    func roundedUp_frames_EdgeCases() async throws {
        #expect(
            try Timecode(.components(h: 23, m: 59, s: 59, f: 23, sf: 0), at: .fps24)
                .roundedUp(toNearest: .frames)
                .components
            == Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: 0)
        )
        
        // 'exactly' throws error because result would be 24:00:00:00
        #expect(throws: (any Error).self) {
            try Timecode(.components(h: 23, m: 59, s: 59, f: 23, sf: 1), at: .fps24)
                .roundedUp(toNearest: .frames)
        }
    }
    
    @Test
    func roundedUp_subFrames() async throws {
        // subFrames has no effect
        
        #expect(
            try Timecode(.zero, at: .fps24).roundedUp(toNearest: .subFrames)
                .components
            == Timecode.Components()
        )
        
        #expect(
            try Timecode(.components(sf: 1), at: .fps24).roundedUp(toNearest: .subFrames)
                .components
            == Timecode.Components(sf: 1)
        )
        
        #expect(
            try Timecode(.components(f: 1), at: .fps24).roundedUp(toNearest: .subFrames)
                .components
            == Timecode.Components(f: 1)
        )
        
        #expect(
            try Timecode(.components(f: 1, sf: 1), at: .fps24).roundedUp(toNearest: .subFrames)
                .components
            == Timecode.Components(f: 1, sf: 1)
        )
    }
    
    // MARK: - Rounding Down
    
    @Test
    func roundedDown_days() async throws {
        #expect(
            Timecode(.zero, at: .fps24).roundedDown(toNearest: .days)
                .components
            == Timecode.Components()
        )
        
        #expect(
            try Timecode(.components(sf: 1), at: .fps24, limit: .max100Days)
                .roundedDown(toNearest: .days)
                .components
            == Timecode.Components(d: 0)
        )
        
        #expect(
            try Timecode(.components(f: 1), at: .fps24, limit: .max100Days)
                .roundedDown(toNearest: .days)
                .components
            == Timecode.Components(d: 0)
        )
        
        #expect(
            try Timecode(.components(s: 1), at: .fps24, limit: .max100Days)
                .roundedDown(toNearest: .days)
                .components
            == Timecode.Components(d: 0)
        )
        
        #expect(
            try Timecode(.components(m: 1), at: .fps24, limit: .max100Days)
                .roundedDown(toNearest: .days)
                .components
            == Timecode.Components(d: 0)
        )
        
        #expect(
            try Timecode(.components(h: 1), at: .fps24, limit: .max100Days)
                .roundedDown(toNearest: .days)
                .components
            == Timecode.Components(d: 0)
        )
        
        #expect(
            try Timecode(.components(m: 1, s: 1, f: 1, sf: 1), at: .fps24, limit: .max100Days)
                .roundedDown(toNearest: .days)
                .components
            == Timecode.Components(d: 0)
        )
        
        #expect(
            try Timecode(.components(h: 1, m: 1, s: 1, f: 1, sf: 1), at: .fps24, limit: .max100Days)
                .roundedDown(toNearest: .days)
                .components
            == Timecode.Components(d: 0)
        )
        
        #expect(
            try Timecode(.components(d: 1), at: .fps24, limit: .max100Days)
                .roundedDown(toNearest: .days)
                .components
            == Timecode.Components(d: 1)
        )
        
        #expect(
            try Timecode(.components(d: 1, h: 0, m: 1, s: 1, f: 1, sf: 1), at: .fps24, limit: .max100Days)
                .roundedDown(toNearest: .days)
                .components
            == Timecode.Components(d: 1)
        )
    }
    
    @Test
    func roundedDown_hours() async throws {
        #expect(
            Timecode(.zero, at: .fps24).roundedDown(toNearest: .hours)
                .components
            == Timecode.Components()
        )
        
        #expect(
            try Timecode(.components(sf: 1), at: .fps24).roundedDown(toNearest: .hours)
                .components
            == Timecode.Components(h: 0)
        )
        
        #expect(
            try Timecode(.components(f: 1), at: .fps24).roundedDown(toNearest: .hours)
                .components
            == Timecode.Components(h: 0)
        )
        
        #expect(
            try Timecode(.components(s: 1), at: .fps24).roundedDown(toNearest: .hours)
                .components
            == Timecode.Components(h: 0)
        )
        
        #expect(
            try Timecode(.components(m: 1), at: .fps24).roundedDown(toNearest: .hours)
                .components
            == Timecode.Components(h: 0)
        )
        
        #expect(
            try Timecode(.components(h: 1), at: .fps24).roundedDown(toNearest: .hours)
                .components
            == Timecode.Components(h: 1)
        )
        
        #expect(
            try Timecode(.components(m: 1, s: 1, f: 1, sf: 1), at: .fps24).roundedDown(toNearest: .hours)
                .components
            == Timecode.Components(h: 0)
        )
        
        #expect(
            try Timecode(.components(d: 1, h: 0, m: 1, s: 1, f: 1, sf: 1), at: .fps24, limit: .max100Days)
                .roundedDown(toNearest: .hours)
                .components
            == Timecode.Components(d: 1, h: 0)
        )
    }
    
    @Test
    func roundedDown_minutes() async throws {
        #expect(
            Timecode(.zero, at: .fps24)
                .roundedDown(toNearest: .minutes)
                .components
            == Timecode.Components()
        )
        
        #expect(
            try Timecode(.components(sf: 1), at: .fps24).roundedDown(toNearest: .minutes)
                .components
            == Timecode.Components(m: 0)
        )
        
        #expect(
            try Timecode(.components(f: 1), at: .fps24).roundedDown(toNearest: .minutes)
                .components
            == Timecode.Components(m: 0)
        )
        
        #expect(
            try Timecode(.components(f: 1, sf: 1), at: .fps24).roundedDown(toNearest: .minutes)
                .components
            == Timecode.Components(m: 0)
        )
        
        #expect(
            try Timecode(.components(s: 2), at: .fps24).roundedDown(toNearest: .minutes)
                .components
            == Timecode.Components(m: 0)
        )
        
        #expect(
            try Timecode(.components(s: 2, sf: 1), at: .fps24).roundedDown(toNearest: .minutes)
                .components
            == Timecode.Components(m: 0)
        )
        
        #expect(
            try Timecode(.components(s: 2, f: 1), at: .fps24).roundedDown(toNearest: .minutes)
                .components
            == Timecode.Components(m: 0)
        )
        
        #expect(
            try Timecode(.components(s: 2, f: 1, sf: 1), at: .fps24).roundedDown(toNearest: .minutes)
                .components
            == Timecode.Components(m: 0)
        )
        
        #expect(
            try Timecode(.components(m: 1), at: .fps24).roundedDown(toNearest: .minutes)
                .components
            == Timecode.Components(m: 1)
        )
        
        #expect(
            try Timecode(.components(m: 1, sf: 1), at: .fps24).roundedDown(toNearest: .minutes)
                .components
            == Timecode.Components(m: 1)
        )
        
        #expect(
            try Timecode(.components(m: 1, f: 1), at: .fps24).roundedDown(toNearest: .minutes)
                .components
            == Timecode.Components(m: 1)
        )
        
        #expect(
            try Timecode(.components(m: 1, s: 1), at: .fps24).roundedDown(toNearest: .minutes)
                .components
            == Timecode.Components(m: 1)
        )
        
        #expect(
            try Timecode(.components(h: 1), at: .fps24).roundedDown(toNearest: .minutes)
                .components
            == Timecode.Components(h: 1)
        )
        
        #expect(
            try Timecode(.components(h: 1, m: 1), at: .fps24).roundedDown(toNearest: .minutes)
                .components
            == Timecode.Components(h: 1, m: 1)
        )
        
        #expect(
            try Timecode(.components(h: 1, m: 1, f: 1), at: .fps24).roundedDown(toNearest: .minutes)
                .components
            == Timecode.Components(h: 1, m: 1)
        )
    }
    
    @Test
    func roundedDown_seconds() async throws {
        #expect(
            Timecode(.zero, at: .fps24).roundedDown(toNearest: .seconds)
                .components
            == Timecode.Components()
        )
        
        #expect(
            try Timecode(.components(sf: 1), at: .fps24).roundedDown(toNearest: .seconds)
                .components
            == Timecode.Components(s: 0)
        )
        
        #expect(
            try Timecode(.components(f: 1), at: .fps24).roundedDown(toNearest: .seconds)
                .components
            == Timecode.Components(s: 0)
        )
        
        #expect(
            try Timecode(.components(f: 1, sf: 1), at: .fps24).roundedDown(toNearest: .seconds)
                .components
            == Timecode.Components(s: 0)
        )
        
        #expect(
            try Timecode(.components(s: 2), at: .fps24).roundedDown(toNearest: .seconds)
                .components
            == Timecode.Components(s: 2)
        )
        
        #expect(
            try Timecode(.components(s: 2, sf: 1), at: .fps24).roundedDown(toNearest: .seconds)
                .components
            == Timecode.Components(s: 2)
        )
        
        #expect(
            try Timecode(.components(s: 2, f: 1), at: .fps24).roundedDown(toNearest: .seconds)
                .components
            == Timecode.Components(s: 2)
        )
        
        #expect(
            try Timecode(.components(s: 2, f: 1, sf: 1), at: .fps24).roundedDown(toNearest: .seconds)
                .components
            == Timecode.Components(s: 2)
        )
        
        #expect(
            try Timecode(.components(h: 1, s: 2, f: 1, sf: 1), at: .fps24).roundedDown(toNearest: .seconds)
                .components
            == Timecode.Components(h: 1, s: 2)
        )
    }
    
    @Test
    func roundedDown_frames() async throws {
        #expect(
            Timecode(.zero, at: .fps23_976).roundedDown(toNearest: .frames)
                .components
            == Timecode.Components()
        )
        
        #expect(
            try Timecode(.components(sf: 1), at: .fps23_976).roundedDown(toNearest: .frames)
                .components
            == Timecode.Components()
        )
        
        #expect(
            try Timecode(.components(f: 1), at: .fps23_976).roundedDown(toNearest: .frames)
                .components
            == Timecode.Components(f: 1)
        )
        
        #expect(
            try Timecode(.components(f: 1, sf: 1), at: .fps23_976).roundedDown(toNearest: .frames)
                .components
            == Timecode.Components(f: 1)
        )
    }
    
    @Test
    func roundedDown_subFrames() async throws {
        // subFrames has no effect
        
        #expect(
            Timecode(.zero, at: .fps23_976).roundedDown(toNearest: .subFrames)
                .components
            == Timecode.Components()
        )
        
        #expect(
            try Timecode(.components(sf: 1), at: .fps23_976).roundedDown(toNearest: .subFrames)
                .components
            == Timecode.Components(sf: 1)
        )
        
        #expect(
            try Timecode(.components(f: 1), at: .fps23_976).roundedDown(toNearest: .subFrames)
                .components
            == Timecode.Components(f: 1)
        )
        
        #expect(
            try Timecode(.components(f: 1, sf: 1), at: .fps23_976).roundedDown(toNearest: .subFrames)
                .components
            == Timecode.Components(f: 1, sf: 1)
        )
    }
}
