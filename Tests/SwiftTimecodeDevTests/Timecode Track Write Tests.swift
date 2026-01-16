//
//  Timecode Track Write Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import AVFoundation
@testable import SwiftTimecodeCore
@testable import SwiftTimecodeAV
import Testing

// @Suite struct TimecodeTrackWriteTests {
//     /// This is not a unit test. It is a development test harness.
//     @available(macOS 13.0, iOS 9999, tvOS 9999, watchOS 9999, visionOS 9999, *)
//     @Test
//     func testReplaceTimecodeTrack() async throws {
//         // parameters
//         let inputURL = URL.desktopDirectory
//             .appendingPathComponent("Movie.mp4")
//         let outputURL = URL.desktopDirectory
//             .appendingPathComponent("Movie-Processed.mov")
// 
//         // load movie off disk
// 
//         print("Loading movie from disk...")
//         let movie = AVMovie(url: inputURL)
// 
//         print("Creating mutable copy of movie in memory...")
//         let mutableMovie = try #require(movie.mutableCopy() as? AVMutableMovie)
// 
//         print("Adding timecode track to mutable movie...")
// 
//         // replace existing timecode track if it exists, otherwise add a new timecode track
//         try await mutableMovie.replaceTimecodeTrack(
//             startTimecode: Timecode(.components(h: 0, m: 59, s: 50, f: 00), at: .fps24),
//             fileType: .mov
//         )
// 
//         print("Exporting mutated movie to disk...")
// 
//         // export
//         let export = try #require(
//             AVAssetExportSession(
//                 asset: mutableMovie,
//                 presetName: AVAssetExportPresetPassthrough
//             )
//         )
// 
//         export.outputFileType = .mov
//         export.outputURL = outputURL
// 
//         // wait for export synchronously
//         let exporter = ObservableExporter(
//             session: export,
//             pollingInterval: 1.0,
//             progress: Binding<Double>(
//                 get: { 0 },
//                 set: { prog, _ in
//                     let percentString = String(format: "%.0f", prog * 100) + "%"
//                     print(percentString)
//                 }
//             )
//         )
//         let status = try await exporter.export()
//         print("100%")
//         print("Done, status:", status.rawValue)
//     }
// }
// 
// import SwiftUI
// 
// /// Wrapper for `AVAssetExportSession` to update Combine/SwiftUI binding with progress
// /// at a specified interval.
// actor ObservableExporter {
//     var progressTimer: Timer?
//     let session: AVAssetExportSession
//     public let pollingInterval: TimeInterval
//     public let progress: Binding<Double>
//     public private(set) var duration: TimeInterval?
// 
//     init(session: AVAssetExportSession,
//          pollingInterval: TimeInterval = 0.1,
//          progress: Binding<Double>) {
//         self.session = session
//         self.pollingInterval = pollingInterval
//         self.progress = progress
//     }
// 
//     func export() async throws -> AVAssetExportSession.Status {
//         progressTimer = Timer(timeInterval: pollingInterval, repeats: true) { [weak self] timer in
//             Task { await self?.timerFired() }
//         }
//         RunLoop.main.add(progressTimer!, forMode: .common)
//         let startDate = Date()
//         await session.export()
//         progressTimer?.invalidate()
//         let endDate = Date()
//         duration = endDate.timeIntervalSince(startDate)
//         if let error = session.error {
//             throw error
//         } else {
//             return session.status
//         }
//     }
// 
//     private func timerFired() {
//         self.progress.wrappedValue = Double(self.session.progress)
//     }
// }
