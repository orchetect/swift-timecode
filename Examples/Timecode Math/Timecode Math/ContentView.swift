//
//  ContentView.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecode
import SwiftTimecodeUI
import SwiftUI

struct ContentView: View {
    @State private var frameRate: TimecodeFrameRate = .fps24

    var body: some View {
        VStack(spacing: 20) {
            Form {
                Picker("Frame Rate", selection: $frameRate) {
                    ForEach(TimecodeFrameRate.allCases) { rate in
                        Text(rate.stringValueVerbose).id(rate)
                    }
                }

                ExpressionsView(frameRate: frameRate).id(frameRate)
            }
            .formStyle(.grouped)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
