//
//  Components Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import Testing

@Suite struct Timecode_Components_Tests {
    fileprivate typealias C = Timecode.Component
    
    // MARK: - Init Dictionary
    
    @Test
    func initDictionaryA() async {
        let dict: [Timecode.Component: Int] = [
            .days: 2,
            .hours: 3,
            .minutes: 4,
            .seconds: 5,
            .frames: 6,
            .subFrames: 7
        ]
        
        let components = Timecode.Components(dict)
        
        #expect(components.days == 2)
        #expect(components.hours == 3)
        #expect(components.minutes == 4)
        #expect(components.seconds == 5)
        #expect(components.frames == 6)
        #expect(components.subFrames == 7)
    }
    
    @Test
    func initDictionaryB() async {
        let dict: [Timecode.Component: Int] = [
            .hours: 3,
            .minutes: 4,
            .seconds: 5,
            .frames: 6
        ]
        
        let components = Timecode.Components(dict)
        
        #expect(components.days == 0)
        #expect(components.hours == 3)
        #expect(components.minutes == 4)
        #expect(components.seconds == 5)
        #expect(components.frames == 6)
        #expect(components.subFrames == 0)
    }
    
    @Test
    func initDictionaryC() async {
        let dict: [Timecode.Component: Int] = [:]
        
        let components = Timecode.Components(dict)
        
        #expect(components.days == 0)
        #expect(components.hours == 0)
        #expect(components.minutes == 0)
        #expect(components.seconds == 0)
        #expect(components.frames == 0)
        #expect(components.subFrames == 0)
    }
    
    // MARK: - Dictionary Property
    
    @Test
    func dictionaryA() async {
        let components = Timecode.Components(d: 2, h: 3, m: 4, s: 5, f: 6, sf: 7)
        let dict = components.dictionary
        
        #expect(dict[.days] == 2)
        #expect(dict[.hours] == 3)
        #expect(dict[.minutes] == 4)
        #expect(dict[.seconds] == 5)
        #expect(dict[.frames] == 6)
        #expect(dict[.subFrames] == 7)
    }
    
    @Test
    func dictionaryB() async {
        let components = Timecode.Components(d: 0, h: 3, m: 4, s: 5, f: 6, sf: 0)
        let dict = components.dictionary
        
        #expect(dict[.days] == 0)
        #expect(dict[.hours] == 3)
        #expect(dict[.minutes] == 4)
        #expect(dict[.seconds] == 5)
        #expect(dict[.frames] == 6)
        #expect(dict[.subFrames] == 0)
    }
    
    @Test
    func dictionaryC() async {
        let components = Timecode.Components.zero
        let dict = components.dictionary
        
        #expect(dict[.days] == 0)
        #expect(dict[.hours] == 0)
        #expect(dict[.minutes] == 0)
        #expect(dict[.seconds] == 0)
        #expect(dict[.frames] == 0)
        #expect(dict[.subFrames] == 0)
    }
    
    // MARK: - Init Array
    
    @Test
    func initArrayA() async {
        let array: [(component: Timecode.Component, value: Int)] = [
            (.days, 2),
            (.hours, 3),
            (.minutes, 4),
            (.seconds, 5),
            (.frames, 6),
            (.subFrames, 7)
        ]
        
        let components = Timecode.Components(array)
        
        #expect(components.days == 2)
        #expect(components.hours == 3)
        #expect(components.minutes == 4)
        #expect(components.seconds == 5)
        #expect(components.frames == 6)
        #expect(components.subFrames == 7)
    }
    
    @Test
    func initArrayB() async {
        let array: [(component: Timecode.Component, value: Int)] = [
            (.hours, 3),
            (.minutes, 4),
            (.seconds, 5),
            (.frames, 6)
        ]
        
        let components = Timecode.Components(array)
        
        #expect(components.days == 0)
        #expect(components.hours == 3)
        #expect(components.minutes == 4)
        #expect(components.seconds == 5)
        #expect(components.frames == 6)
        #expect(components.subFrames == 0)
    }
    
    @Test
    func initArrayC() async {
        let array: [(component: Timecode.Component, value: Int)] = []
        
        let components = Timecode.Components(array)
        
        #expect(components.days == 0)
        #expect(components.hours == 0)
        #expect(components.minutes == 0)
        #expect(components.seconds == 0)
        #expect(components.frames == 0)
        #expect(components.subFrames == 0)
    }
    
    // MARK: - Array Property
    
    @Test
    func arrayA() async {
        let components = Timecode.Components(d: 2, h: 3, m: 4, s: 5, f: 6, sf: 7)
        let array = components.array
        
        #expect(array.count == 6)
        
        #expect(array[0].component == .days)
        #expect(array[0].value == 2)
        #expect(array[1].component == .hours)
        #expect(array[1].value == 3)
        #expect(array[2].component == .minutes)
        #expect(array[2].value == 4)
        #expect(array[3].component == .seconds)
        #expect(array[3].value == 5)
        #expect(array[4].component == .frames)
        #expect(array[4].value == 6)
        #expect(array[5].component == .subFrames)
        #expect(array[5].value == 7)
    }
    
    @Test
    func arrayB() async {
        let components = Timecode.Components(d: 0, h: 3, m: 4, s: 5, f: 6, sf: 0)
        let array = components.array
        
        #expect(array.count == 6)
        
        #expect(array[0].component == .days)
        #expect(array[0].value == 0)
        #expect(array[1].component == .hours)
        #expect(array[1].value == 3)
        #expect(array[2].component == .minutes)
        #expect(array[2].value == 4)
        #expect(array[3].component == .seconds)
        #expect(array[3].value == 5)
        #expect(array[4].component == .frames)
        #expect(array[4].value == 6)
        #expect(array[5].component == .subFrames)
        #expect(array[5].value == 0)
    }
    
    @Test
    func arrayC() async {
        let components = Timecode.Components.zero
        let array = components.array
        
        #expect(array.count == 6)
        
        #expect(array[0].component == .days)
        #expect(array[0].value == 0)
        #expect(array[1].component == .hours)
        #expect(array[1].value == 0)
        #expect(array[2].component == .minutes)
        #expect(array[2].value == 0)
        #expect(array[3].component == .seconds)
        #expect(array[3].value == 0)
        #expect(array[4].component == .frames)
        #expect(array[4].value == 0)
        #expect(array[5].component == .subFrames)
        #expect(array[5].value == 0)
    }
    
    // MARK: - Iterators
    
    @Test
    func iteratorA() async {
        let components = Timecode.Components(d: 2, h: 3, m: 4, s: 5, f: 6, sf: 7)
        
        let array = Array(components.makeIterator())
        
        #expect(array.count == 6)
        
        #expect(array[0].component == .days)
        #expect(array[0].value == 2)
        #expect(array[1].component == .hours)
        #expect(array[1].value == 3)
        #expect(array[2].component == .minutes)
        #expect(array[2].value == 4)
        #expect(array[3].component == .seconds)
        #expect(array[3].value == 5)
        #expect(array[4].component == .frames)
        #expect(array[4].value == 6)
        #expect(array[5].component == .subFrames)
        #expect(array[5].value == 7)
    }
    
    @Test
    func iteratorB() async {
        let components = Timecode.Components.zero
        
        let array = Array(components.makeIterator())
        
        #expect(array.count == 6)
        
        #expect(array[0].component == .days)
        #expect(array[0].value == 0)
        #expect(array[1].component == .hours)
        #expect(array[1].value == 0)
        #expect(array[2].component == .minutes)
        #expect(array[2].value == 0)
        #expect(array[3].component == .seconds)
        #expect(array[3].value == 0)
        #expect(array[4].component == .frames)
        #expect(array[4].value == 0)
        #expect(array[5].component == .subFrames)
        #expect(array[5].value == 0)
    }
    
    // MARK: - Validation
    
    /// Baseline test that should be valid at all frame rates and subframes bases.
    @Test(
        arguments: TimecodeFrameRate.allCases
            .flatMap { fr in Timecode.SubFramesBase.allCases.map { base in (fr, base) } }
    )
    func isWithinValidDigitCountsA(frameRate: TimecodeFrameRate, base: Timecode.SubFramesBase) async {
        let components = Timecode.Components(d: 2, h: 3, m: 4, s: 5, f: 6, sf: 7)
        #expect(components.isWithinValidDigitCounts(at: frameRate, base: base))
    }
    
    /// Baseline test that should be valid at all frame rates and subframes bases.
    @Test(
        arguments: TimecodeFrameRate.allCases
            .flatMap { fr in Timecode.SubFramesBase.allCases.map { base in (fr, base) } }
    )
    func isWithinValidDigitCountsB(frameRate: TimecodeFrameRate, base: Timecode.SubFramesBase) async {
        let components = Timecode.Components(d: 99, h: 99, m: 99, s: 99, f: 99, sf: 9)
        #expect(components.isWithinValidDigitCounts(at: frameRate, base: base))
    }
    
    @Test(
        arguments: TimecodeFrameRate.allCases
            .flatMap { fr in Timecode.SubFramesBase.allCases.map { base in (fr, base) } }
    )
    func isWithinValidDigitCountsC(frameRate: TimecodeFrameRate, base: Timecode.SubFramesBase) async {
        let components = Timecode.Components(d: 100)
        #expect(!components.isWithinValidDigitCounts(at: frameRate, base: base))
    }
    
    @Test(
        arguments: TimecodeFrameRate.allCases
            .flatMap { fr in Timecode.SubFramesBase.allCases.map { base in (fr, base) } }
    )
    func isWithinValidDigitCountsD(frameRate: TimecodeFrameRate, base: Timecode.SubFramesBase) async {
        let components = Timecode.Components(h: 100)
        #expect(!components.isWithinValidDigitCounts(at: frameRate, base: base))
    }
    
    @Test(
        arguments: TimecodeFrameRate.allCases
            .flatMap { fr in Timecode.SubFramesBase.allCases.map { base in (fr, base) } }
    )
    func isWithinValidDigitCountsE(frameRate: TimecodeFrameRate, base: Timecode.SubFramesBase) async {
        let components = Timecode.Components(m: 100)
        #expect(!components.isWithinValidDigitCounts(at: frameRate, base: base))
    }
    
    @Test(
        arguments: TimecodeFrameRate.allCases
            .flatMap { fr in Timecode.SubFramesBase.allCases.map { base in (fr, base) } }
    )
    func isWithinValidDigitCountsF(frameRate: TimecodeFrameRate, base: Timecode.SubFramesBase) async {
        let components = Timecode.Components(s: 100)
        #expect(!components.isWithinValidDigitCounts(at: frameRate, base: base))
    }
    
    @Test(
        arguments: TimecodeFrameRate.allCases.filter({ $0.numberOfDigits == 2 })
            .flatMap { fr in Timecode.SubFramesBase.allCases.map { base in (fr, base) } }
    )
    func isWithinValidDigitCountsG(frameRate: TimecodeFrameRate, base: Timecode.SubFramesBase) async {
        let components = Timecode.Components(f: 100)
        #expect(!components.isWithinValidDigitCounts(at: frameRate, base: base))
    }
    
    @Test(
        arguments: TimecodeFrameRate.allCases.filter({ $0.numberOfDigits == 3 })
            .flatMap { fr in Timecode.SubFramesBase.allCases.map { base in (fr, base) } }
    )
    func isWithinValidDigitCountsH(frameRate: TimecodeFrameRate, base: Timecode.SubFramesBase) async {
        let components = Timecode.Components(f: 1000)
        #expect(!components.isWithinValidDigitCounts(at: frameRate, base: base))
    }
}
