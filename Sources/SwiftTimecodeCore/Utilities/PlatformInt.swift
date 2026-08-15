//
//  PlatformInt.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if _pointerBitWidth(_64) || _pointerBitWidth(_128)

/// Signed integer type that aliases to the appropriate concrete type for the target platform.
/// Resolves to `Int` on 64-bit platforms and `Int64` on 32-bit platforms (including `wasm32`,
/// `armv7k`, and `arm64_32`).
///
/// > Tip:
/// >
/// > Consumers building for 64-bit platforms only may use `Int` at call-sites without any special
/// > accommodations. Consumers for 32-bit platforms or consumers building cross-platform modules
/// > for both 64- and 32-bit targets from one source should wrap values at call-sites with `Int64`.
///
/// > Note:
/// >
/// > This type is used only as a retroactive solution for providing cross-platform compatibility to
/// > this library in a non-breaking way for existing 64-bit bit platform consumers while adding
/// > support for 32-bit platforms with little to no compromises. A future version of this library
/// > may remove this type alias and adopt specific bit-width integer types that are stable across
/// > all architectures.
public typealias PlatformInt = Int

#elseif _pointerBitWidth(_32)

/// Signed integer type that aliases to the appropriate concrete type for the target platform.
/// Resolves to `Int` on 64-bit platforms and `Int64` on 32-bit platforms (including `wasm32`,
/// `armv7k`, and `arm64_32`).
///
/// > Tip:
/// >
/// > Consumers building for 64-bit platforms only may use `Int` at call-sites without any special
/// > accommodations. Consumers for 32-bit platforms or consumers building cross-platform modules
/// > for both 64- and 32-bit targets from one source should wrap values at call-sites with `Int64`.
///
/// > Note:
/// >
/// > This type is used only as a retroactive solution for providing cross-platform compatibility to
/// > this library in a non-breaking way for existing 64-bit bit platform consumers while adding
/// > support for 32-bit platforms with little to no compromises. A future version of this library
/// > may remove this type alias and adopt specific bit-width integer types that are stable across
/// > all architectures.
public typealias PlatformInt = Int64

#else
#error("Unsupported pointer width — PlatformInt needs a mapping for this platform.")
#endif
