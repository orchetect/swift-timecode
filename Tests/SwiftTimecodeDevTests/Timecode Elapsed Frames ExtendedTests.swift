//
//  Timecode Elapsed Frames ExtendedTests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

// ==============================================================================
// NOTE:
// ==============================================================================
// This not a unit test. It is a brute-force development test not meant to be run
// frequently, but as a diagnostic testbed only when major changes are made to
// the library to ensure that conversions are accurate.
// Depending on how many limits and frame rates are enabled, this test may take
// several minutes to complete -- possibly 20+ minutes even on a modern Mac.
// ==============================================================================

// @testable import SwiftTimecodeCore
// import Testing
// import TestingExtensions
// import struct XCTestExtensions.SegmentedProgress
//
// @Suite struct Timecode_ExtendedTests {
//     // MARK: - Arguments
//
//     static let limits: [Timecode.UpperLimit] =
//     //  Timecode.UpperLimit.allCases
//         [.max24Hours]
//     //  .max100Days
//
//     static let frameRates: [TimecodeFrameRate] =
//         TimecodeFrameRate.allCases
//     //  TimecodeFrameRate.allDrop
//     //  TimecodeFrameRate.allNonDrop
//     //  [.fps24, .fps30]
//
//     let isLoggingEnabled: Bool = false
//
//     // MARK: - Dev Test
//
//     /// Test conversions from `components(of:)` and `frameCount(of:)`.
//     @Test(arguments: limits.flatMap { limit in frameRates.map { frameRate in (limit, frameRate) } })
//     func timecode_Iterative(limit: Timecode.UpperLimit, frameRate: TimecodeFrameRate) async {
//         let tc = Timecode(.zero, at: frameRate, limit: limit)
//
//         // log status
//         if isLoggingEnabled { print("Testing all frames in \(tc.upperLimit) at \(frameRate.stringValue)... ", terminator: "") }
//
//         var failures: [(Int, Timecode.Components)] = []
//
//         let ubound = tc.frameRate.maxTotalFrames(in: tc.upperLimit)
//
//         var prog = SegmentedProgress(0 ... ubound, segments: 20, roundedToPlaces: 0)
//
//         for i in 0 ... ubound {
//             let vals = Timecode.components(
//                 of: .init(.frames(i), base: tc.subFramesBase),
//                 at: tc.frameRate
//             )
//
//             if i != Timecode.frameCount(
//                 of: vals,
//                 at: tc.frameRate,
//                 base: tc.subFramesBase
//             ).wholeFrames
//
//             { failures.append((i, vals)) }
//
//             // log status
//             if isLoggingEnabled, let percentageToPrint = prog.progress(value: i) {
//                 print("\(percentageToPrint) ", terminator: "")
//             }
//         }
//         print("") // finalize log with newline char
//
//         #expect(
//             failures.count == 0,
//             "Failed iterative test for \(frameRate.stringValueVerbose) with \(failures.count) failures."
//         )
//
//         if !failures.isEmpty {
//             print(
//                 "First",
//                 frameRate.stringValueVerbose,
//                 "failure: input elapsed frames",
//                 failures.first!.0,
//                 "converted to components",
//                 failures.first!.1,
//                 "converted back to",
//                 Timecode.frameCount(
//                     of: failures.first!.1,
//                     at: tc.frameRate,
//                     base: tc.subFramesBase
//                 ),
//                 "elapsed frames."
//             )
//         }
//         if failures.count > 1 {
//             print(
//                 "Last",
//                 frameRate.stringValueVerbose,
//                 "failure: input elapsed frames",
//                 failures.last!.0,
//                 "converted to components",
//                 failures.last!.1,
//                 "converted back to",
//                 Timecode.frameCount(
//                     of: failures.last!.1,
//                     at: tc.frameRate,
//                     base: tc.subFramesBase
//                 ),
//                 "elapsed frames."
//             )
//         }
//
//         if isLoggingEnabled { print("Done testing \(frameRate.stringValueVerbose).") }
//     }
// }
