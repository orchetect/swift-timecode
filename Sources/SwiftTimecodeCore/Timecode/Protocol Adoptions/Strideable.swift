//
//  Strideable.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#endif

extension Timecode: Strideable {
    public typealias Stride = Int

    /// Returns a new instance advanced by specified time components.
    /// Same as calling `.adding(.components(f: n), by: .clamping)` but implemented in order to
    /// allow Timecode to conform to `Strideable`.
    /// Will clamp to valid timecode range.
    public func advanced(by n: Stride) -> Self {
        adding(Components(f: n), by: .clamping)
    }

    /// Distance between two timecode expressed as number of frames.
    /// Implemented in order to allow Timecode to conform to `Strideable`.
    public func distance(to other: Self) -> Stride {
        other.frameCount.wholeFrames - frameCount.wholeFrames
    }
}
