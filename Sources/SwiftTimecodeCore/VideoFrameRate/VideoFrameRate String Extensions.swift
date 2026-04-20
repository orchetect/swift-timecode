//
//  VideoFrameRate String Extensions.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2026 Steffan Andrews • Licensed under MIT License
//

extension String {
    /// Convenience method to call ``VideoFrameRate/init(stringValue:)``.
    @_disfavoredOverload
    public var videoFrameRate: VideoFrameRate? {
        VideoFrameRate(stringValue: self)
    }
}
