//
//  TimecodeField Environment.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftTimecodeCore
import SwiftUI

// MARK: - Environment Values

// MARK: - TimecodeFieldInputRejectionFeedback

@_documentation(visibility: internal)
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension EnvironmentValues {
    /// Sets the rejected input feedback behavior (visual & audible) for ``TimecodeField`` views.
    @Entry public var timecodeFieldInputRejectionFeedback: TimecodeField.InputRejectionFeedback? = .platformDefault
}

// MARK: - TimecodeFieldHighlightStyle

@_documentation(visibility: internal)
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension EnvironmentValues {
    /// Sets the component highlight style for ``TimecodeField`` views.
    /// By default, the application's `accentColor` is used.
    @Entry public var timecodeFieldHighlightStyle: AnyShapeStyle? = AnyShapeStyle(.tint)
}

// MARK: - TimecodeFieldInputStyle

@_documentation(visibility: internal)
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension EnvironmentValues {
    /// Sets the data entry input style for ``TimecodeField`` views.
    @Entry public var timecodeFieldInputStyle: TimecodeField.InputStyle = {
        #if os(macOS)
        .continuousWithinComponent
        #else
        .autoAdvance
        #endif
    }()
}

// MARK: - TimecodeFieldInputWrapping

@_documentation(visibility: internal)
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension EnvironmentValues {
    /// Sets the focus wrapping behavior for ``TimecodeField`` views.
    @Entry public var timecodeFieldInputWrapping: TimecodeField.InputWrapping = .noWrap
}

// MARK: - TimecodeFieldPastePolicy

@_documentation(visibility: internal)
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension EnvironmentValues {
    /// Sets the timecode paste policy for the view.
    @Entry public var timecodeFieldPastePolicy: TimecodeField.PastePolicy = .preserveLocalProperties
}

// MARK: - TimecodeFieldReturnAction

@_documentation(visibility: internal)
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension EnvironmentValues {
    /// Sets the `Return` key action for ``TimecodeField`` views.
    @Entry public var timecodeFieldReturnAction: TimecodeField.FieldAction? = nil
}

// MARK: - TimecodeFieldEscapeAction

@_documentation(visibility: internal)
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension EnvironmentValues {
    /// Sets the `Escape` key action for ``TimecodeField`` views.
    @Entry public var timecodeFieldEscapeAction: TimecodeField.FieldAction? = nil
}

// MARK: - TimecodeFieldValidationPolicy

@_documentation(visibility: internal)
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension EnvironmentValues {
    /// Sets timecode component validation policy for ``TimecodeField`` views.
    @Entry public var timecodeFieldValidationPolicy: TimecodeField.ValidationPolicy = .enforceValid
}

#endif
