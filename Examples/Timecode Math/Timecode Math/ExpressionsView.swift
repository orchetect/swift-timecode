//
//  ExpressionsView.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecode
import SwiftTimecodeUI
import SwiftUI

struct ExpressionsView: View {
    let frameRate: TimecodeFrameRate

    var body: some View {
        Group {
            TimecodeMathExpressionView(
                operation: .add,
                lhs: Timecode(.components(h: 1), at: frameRate, by: .allowingInvalid),
                rhs: Timecode(.components(m: 20), at: frameRate, by: .allowingInvalid)
            )

            TimecodeMathExpressionView(
                operation: .subtract,
                lhs: Timecode(.components(h: 1), at: frameRate, by: .allowingInvalid),
                rhs: Timecode(.components(m: 20), at: frameRate, by: .allowingInvalid)
            )

            DoubleMathExpressionView(
                operation: .multiply,
                lhs: Timecode(.components(h: 1), at: frameRate, by: .allowingInvalid),
                rhs: 2.5
            )

            DoubleMathExpressionView(
                operation: .divide,
                lhs: Timecode(.components(h: 1), at: frameRate, by: .allowingInvalid),
                rhs: 2.5
            )
        }
        .font(.title3)
        .foregroundStyle(.primary)
        .timecodeFormat([.showSubFrames])
        .timecodeSeparatorStyle(.secondary)
        .timecodeSubFramesStyle(.secondary, scale: .secondary)
        .timecodeFieldInputStyle(.autoAdvance)
        .timecodeFieldInputWrapping(.noWrap)
        .timecodeFieldValidationPolicy(.enforceValid)
    }
}
