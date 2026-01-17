//
//  TimecodeFrameRate CompatibleGroup Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import Testing

@Suite struct TimecodeFrameRate_CompatibleGroup_Tests {
    @Test(arguments: TimecodeFrameRate.allCases)
    func compatibleGroup_EnsureAllFrameRateCasesAreHandled(frameRate: TimecodeFrameRate) async {
        // If an exception is thrown here, it means that a frame rate has not been added to the CompatibleGroup.table
        _ = frameRate.compatibleGroup
    }
    
    @Test
    func testCompatibleGroup_compatibleGroup() async {
        // methods basic spot-check
        
        // NTSC
        #expect(TimecodeFrameRate.fps29_97.compatibleGroup == .ntscColor)
        #expect(TimecodeFrameRate.fps59_94.compatibleGroup == .ntscColor)
        #expect(TimecodeFrameRate.fps29_97.isCompatible(with: .fps59_94))
        
        // NTSC Drop
        #expect(TimecodeFrameRate.fps29_97d.compatibleGroup == .ntscDrop)
        #expect(TimecodeFrameRate.fps59_94d.compatibleGroup == .ntscDrop)
        #expect(TimecodeFrameRate.fps29_97d.isCompatible(with: .fps59_94d))
        
        // Whole
        #expect(TimecodeFrameRate.fps24.compatibleGroup == .whole)
        #expect(TimecodeFrameRate.fps30.compatibleGroup == .whole)
        #expect(TimecodeFrameRate.fps24.isCompatible(with: .fps30))
        
        // NTSC Color Wall Time
        #expect(TimecodeFrameRate.fps30d.compatibleGroup == .ntscColorWallTime)
        #expect(TimecodeFrameRate.fps60d.compatibleGroup == .ntscColorWallTime)
        #expect(TimecodeFrameRate.fps30d.isCompatible(with: .fps60d))
    }
    
    @Test(arguments: TimecodeFrameRate.CompatibleGroup.table)
    func testCompatibleGroup_compatibleGroupRates(grouping: (key: TimecodeFrameRate.CompatibleGroup, value: [TimecodeFrameRate])) async {
        let otherGroupingsRates = TimecodeFrameRate.CompatibleGroup.table
            .compactMap { $0.key != grouping.key ? $0 : nil }
            .reduce(into: []) { $0 += ($1.value) }
        
        for rate in grouping.value {
            #expect(rate.compatibleGroupRates == grouping.value)
        }
        
        for rate in otherGroupingsRates {
            #expect(rate.compatibleGroupRates != grouping.value)
        }
    }
    
    @Test(arguments: TimecodeFrameRate.CompatibleGroup.table)
    func testCompatibleGroup_isCompatible(grouping: (key: TimecodeFrameRate.CompatibleGroup, value: [TimecodeFrameRate])) async {
        let otherGroupingsRates = TimecodeFrameRate.CompatibleGroup.table
            .compactMap { $0.key != grouping.key ? $0 : nil }
            .reduce(into: []) { $0 += ($1.value) }
        
        // test against other rates in the same grouping
        for srcRate in grouping.value {
            for destRate in grouping.value {
                #expect(srcRate.isCompatible(with: destRate))
            }
        }
        
        // test against rates in all the other groupings
        for srcRate in grouping.value {
            for destRate in otherGroupingsRates {
                #expect(!srcRate.isCompatible(with: destRate))
            }
        }
    }
}
