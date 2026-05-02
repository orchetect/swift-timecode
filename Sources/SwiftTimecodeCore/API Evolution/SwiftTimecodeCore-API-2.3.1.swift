//
//  SwiftTimecodeCore-API-2.3.1.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: API Changes in SwiftTimecode 2.3.1

@_documentation(visibility: internal)
extension Timecode {
    @available(*, deprecated, renamed: "stringValueVerbose")
    public var verboseDescription: String {
        stringValueVerbose
    }
}

@_documentation(visibility: internal)
extension Timecode.StringFormat {
    @available(*, deprecated, message: "Use [.showSubFrames] instead.")
    public static let showSubFrames: Self = [.showSubFrames]
}
