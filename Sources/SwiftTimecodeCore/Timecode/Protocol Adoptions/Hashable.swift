//
//  Hashable.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2026 Steffan Andrews • Licensed under MIT License
//

extension Timecode: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(components)
        hasher.combine(properties)
    }
}
