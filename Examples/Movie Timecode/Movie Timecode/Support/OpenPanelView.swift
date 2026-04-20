//
//  OpenPanelView.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import Foundation
import SwiftUI

/// `NSOpenPanel` SwiftUI wrapper view.
/// Do not instantiate directly. Instead, use the `.fileOpenPanel( ... )` view modifier.
///
/// Updated 2026-Apr-8
struct OpenPanelView<Content: View>: View {
    @Binding var isPresented: Bool
    let setup: ((_ panel: NSOpenPanel) -> Void)?
    let completion: (_ urls: [URL]?) -> Void
    let content: Content

    @State private var panel: NSOpenPanel?

    var body: some View {
        content
            .onChange(of: isPresented, initial: true) { oldValue, newValue in
                Task { await newValue ? present() : close() }
            }
    }

    private func present() async {
        let newPanel = NSOpenPanel()
        setup?(newPanel)
        panel = newPanel

        var selectedURLs: [URL]?

        isPresented = true
        if newPanel.runModal() == .OK {
            selectedURLs = newPanel.urls
        }

        completion(selectedURLs)
        panel = nil
        isPresented = false
    }

    private func close() async {
        panel?.cancelOperation(nil)
        panel = nil
        isPresented = false
    }
}

// MARK: - View Modifier

extension View {
    /// `NSOpenPanel` SwiftUI wrapper view.
    public func fileOpenPanel(
        isPresented: Binding<Bool>,
        setup: ((NSOpenPanel) -> Void)? = nil,
        completion: @escaping (_ urls: [URL]?) -> Void
    ) -> some View {
        OpenPanelView(
            isPresented: isPresented,
            setup: setup,
            completion: completion,
            content: self
        )
    }
}

// MARK: - NSOpenPanel Extensions

extension NSOpenPanel {
    /// Convenience init to assign common properties at the time of initialization.
    convenience init(
        allowsMultipleSelection: Bool,
        allowFiles: Bool,
        allowDirectories: Bool
    ) {
        self.init()
        self.allowsMultipleSelection = allowsMultipleSelection
        canChooseDirectories = allowFiles
        canChooseFiles = allowFiles
    }

    /// Presents the dialog modally asynchronously and calls a completion handler upon the user closing the dialog.
    func present(
        completion: (_ urls: [URL]?) -> Void
    ) {
        var selectedURLs: [URL]?

        if runModal() == .OK {
            selectedURLs = urls
        }

        completion(selectedURLs)
    }
}

#endif
