//
//  Component Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import Testing

@Suite struct Timecode_Component_Tests {
    fileprivate typealias C = Timecode.Component
    
    // MARK: - Comparable
    
    @Test
    func comparable() async {
        // baseline
        
        #expect(C.days < C.hours)
        #expect(C.hours < C.minutes)
        #expect(C.minutes < C.seconds)
        #expect(C.seconds < C.frames)
        #expect(C.frames < C.subFrames)
        
        #expect(C.hours > C.days)
        #expect(C.minutes > C.hours)
        #expect(C.seconds > C.minutes)
        #expect(C.frames > C.seconds)
        #expect(C.subFrames > C.frames)
        
        // exhaustive
        
        #expect(!(C.days < C.days))
        #expect(C.days < C.hours)
        #expect(C.days < C.minutes)
        #expect(C.days < C.seconds)
        #expect(C.days < C.frames)
        #expect(C.days < C.subFrames)
        
        #expect(!(C.hours < C.days))
        #expect(!(C.hours < C.hours))
        #expect(C.hours < C.minutes)
        #expect(C.hours < C.seconds)
        #expect(C.hours < C.frames)
        #expect(C.hours < C.subFrames)
        
        #expect(!(C.minutes < C.days))
        #expect(!(C.minutes < C.hours))
        #expect(!(C.minutes < C.minutes))
        #expect(C.minutes < C.seconds)
        #expect(C.minutes < C.frames)
        #expect(C.minutes < C.subFrames)
        
        #expect(!(C.seconds < C.days))
        #expect(!(C.seconds < C.hours))
        #expect(!(C.seconds < C.minutes))
        #expect(!(C.seconds < C.seconds))
        #expect(C.seconds < C.frames)
        #expect(C.seconds < C.subFrames)
        
        #expect(!(C.frames < C.days))
        #expect(!(C.frames < C.hours))
        #expect(!(C.frames < C.minutes))
        #expect(!(C.frames < C.seconds))
        #expect(!(C.frames < C.frames))
        #expect(C.frames < C.subFrames)
        
        #expect(!(C.subFrames < C.days))
        #expect(!(C.subFrames < C.hours))
        #expect(!(C.subFrames < C.minutes))
        #expect(!(C.subFrames < C.seconds))
        #expect(!(C.subFrames < C.frames))
        #expect(!(C.subFrames < C.subFrames))
    }
    
    // MARK: - Next
    
    @Test
    func next_HHMMSSFF() async throws {
        #expect(C.days.next(excluding: [.days, .subFrames]) == .hours)
        #expect(C.hours.next(excluding: [.days, .subFrames]) == .minutes)
        #expect(C.minutes.next(excluding: [.days, .subFrames]) == .seconds)
        #expect(C.seconds.next(excluding: [.days, .subFrames]) == .frames)
        #expect(C.frames.next(excluding: [.days, .subFrames]) == .hours)
        #expect(C.subFrames.next(excluding: [.days, .subFrames]) == .hours)
    }
    
    @Test
    func next_HHMMSSFFXX() async throws {
        #expect(C.days.next(excluding: [.days]) == .hours)
        #expect(C.hours.next(excluding: [.days]) == .minutes)
        #expect(C.minutes.next(excluding: [.days]) == .seconds)
        #expect(C.seconds.next(excluding: [.days]) == .frames)
        #expect(C.frames.next(excluding: [.days]) == .subFrames)
        #expect(C.subFrames.next(excluding: [.days]) == .hours)
    }
    
    @Test
    func next_DDHHMMSSFF() async throws {
        #expect(C.days.next(excluding: [.subFrames]) == .hours)
        #expect(C.hours.next(excluding: [.subFrames]) == .minutes)
        #expect(C.minutes.next(excluding: [.subFrames]) == .seconds)
        #expect(C.seconds.next(excluding: [.subFrames]) == .frames)
        #expect(C.frames.next(excluding: [.subFrames]) == .days)
        #expect(C.subFrames.next(excluding: [.subFrames]) == .days)
    }
    
    @Test
    func next_DDHHMMSSFFXX() async throws {
        #expect(C.days.next(excluding: []) == .hours)
        #expect(C.hours.next(excluding: []) == .minutes)
        #expect(C.minutes.next(excluding: []) == .seconds)
        #expect(C.seconds.next(excluding: []) == .frames)
        #expect(C.frames.next(excluding: []) == .subFrames)
        #expect(C.subFrames.next(excluding: []) == .days)
    }
    
    // MARK: - Previous
    
    @Test
    func previous_HHMMSSFF() async throws {
        #expect(C.days.previous(excluding: [.days, .subFrames]) == .frames)
        #expect(C.hours.previous(excluding: [.days, .subFrames]) == .frames)
        #expect(C.minutes.previous(excluding: [.days, .subFrames]) == .hours)
        #expect(C.seconds.previous(excluding: [.days, .subFrames]) == .minutes)
        #expect(C.frames.previous(excluding: [.days, .subFrames]) == .seconds)
        #expect(C.subFrames.previous(excluding: [.days, .subFrames]) == .frames)
    }
    
    @Test
    func previous_HHMMSSFFXX() async throws {
        #expect(C.days.previous(excluding: [.days]) == .subFrames)
        #expect(C.hours.previous(excluding: [.days]) == .subFrames)
        #expect(C.minutes.previous(excluding: [.days]) == .hours)
        #expect(C.seconds.previous(excluding: [.days]) == .minutes)
        #expect(C.frames.previous(excluding: [.days]) == .seconds)
        #expect(C.subFrames.previous(excluding: [.days]) == .frames)
    }
    
    @Test
    func previous_DDHHMMSSFF() async throws {
        #expect(C.days.previous(excluding: [.subFrames]) == .frames)
        #expect(C.hours.previous(excluding: [.subFrames]) == .days)
        #expect(C.minutes.previous(excluding: [.subFrames]) == .hours)
        #expect(C.seconds.previous(excluding: [.subFrames]) == .minutes)
        #expect(C.frames.previous(excluding: [.subFrames]) == .seconds)
        #expect(C.subFrames.previous(excluding: [.subFrames]) == .frames)
    }
    
    @Test
    func previous_DDHHMMSSFFXX() async throws {
        #expect(C.days.previous(excluding: []) == .subFrames)
        #expect(C.hours.previous(excluding: []) == .days)
        #expect(C.minutes.previous(excluding: []) == .hours)
        #expect(C.seconds.previous(excluding: []) == .minutes)
        #expect(C.frames.previous(excluding: []) == .seconds)
        #expect(C.subFrames.previous(excluding: []) == .frames)
    }
}
