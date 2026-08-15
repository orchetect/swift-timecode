//
//  PlatformInt.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if _pointerBitWidth(_64) || _pointerBitWidth(_128)

/// Signed integer type that aliases to the appropriate concrete type for the target platform.
/// Resolves to `Int` on 64-bit platforms and `Int64` on 32-bit platforms (including `wasm32`,
/// `armv7k`, and `arm64_32`). Note: Do not use this type alias directly. See the documentation
/// discussion text of this type for details.
///
/// > Warning:
/// >
/// > Do not use this type alias directly as it will be removed in a future version of the library.
/// >
/// > If building exclusively for 64-bit platforms, `Int` may be used without any cross-platform
/// > accommodations needed.
/// >
/// > If building for 32-bit platforms, or building for both 64- and 32-bit targets from the same
/// > source, wrapping values at call-sites with `Int64()` will ensure cross-architecture stability.
///
/// > Note:
/// >
/// > This type is used only as a retroactive solution for providing cross-platform compatibility
/// > to the library in a non-breaking way for existing 64-bit bit platforms, while adding support
/// > for 32-bit platforms that would otherwise narrow `Int` bit-width to 32 bits.
public typealias PlatformInt = Int

#elseif _pointerBitWidth(_32)

/// Signed integer type that aliases to the appropriate concrete type for the target platform.
/// Resolves to `Int` on 64-bit platforms and `Int64` on 32-bit platforms (including `wasm32`,
/// `armv7k`, and `arm64_32`). Note: Do not use this type alias directly. See the documentation
/// discussion text of this type for details.
///
/// > Warning:
/// >
/// > Do not use this type alias directly as it will be removed in a future version of the library.
/// >
/// > If building exclusively for 64-bit platforms, `Int` may be used without any cross-platform
/// > accommodations needed.
/// >
/// > If building for 32-bit platforms, or building for both 64- and 32-bit targets from the same
/// > source, wrapping values at call-sites with `Int64()` will ensure cross-architecture stability.
///
/// > Note:
/// >
/// > This type is used only as a retroactive solution for providing cross-platform compatibility
/// > to the library in a non-breaking way for existing 64-bit bit platforms, while adding support
/// > for 32-bit platforms that would otherwise narrow `Int` bit-width to 32 bits.
public typealias PlatformInt = Int64

#else
#error("Unsupported pointer width — PlatformInt needs a mapping for this platform.")
#endif
