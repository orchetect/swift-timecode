//
//  PlatformInt.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2026 Steffan Andrews • Licensed under MIT License
//

/// Integer type used at the library's overflow pinch points — total subframe
/// counts, total audio sample counts, and `Fraction`'s terms — as opposed to
/// per-component values such as `Components`' hours, minutes, seconds and
/// frames, which remain `Int`.
///
/// `Int` on 64-bit platforms, so nothing changes for the vast majority of
/// consumers. `Int64` on 32-bit platforms (wasm32, watchOS armv7k/arm64_32),
/// where `Int` cannot represent these values at all:
///
/// - a `.max100Days` subframe count is at least `2_073_600 * 100 * 80 =
///   16_588_800_000` for every frame rate at the 80- and 100-subframe bases
/// - an audio sample count is `4_147_200_000` at 24 hours / 48 kHz
///
/// against an `Int.max` of `2_147_483_647`. Computing either in `Int` traps on
/// overflow, and because the subframe bound is recomputed inside every wrapping
/// add, that took *all* arithmetic on a `.max100Days` timecode with it.
///
/// Consumers building for both 64- and 32-bit targets from one source can wrap
/// values at the API boundary (`Int64(…)`) or use the same fence.
#if _pointerBitWidth(_64)
public typealias PlatformInt = Int
#elseif _pointerBitWidth(_32)
public typealias PlatformInt = Int64
#else
#error("Unsupported pointer width — PlatformInt needs a mapping for this platform.")
#endif
