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
/// > Note:
/// >
/// > This type is used only as a retroactive solution for providing cross-platform compatibility
/// > to the library in a non-breaking way for existing 64-bit bit platforms, while adding support
/// > for 32-bit platforms that would otherwise narrow `Int` bit-width to 32 bits.
///
/// > Important:
/// >
/// > It is not necessary to use this alias directly unless compiling for both 32- and 64-bit
/// > platforms.
/// >
/// > - If building exclusively for 64-bit platforms, `Int` may be used without any cross-platform
/// >   accommodations needed.
/// >
/// > - If building for 32-bit platforms, `Int64` may be used without any cross-platform
/// >   accommodations needed.
/// >
/// > - If building for both 64- and 32-bit platforms from the same source:
/// >
/// >   Integer literals need no cross-platform accommodations:
/// >
/// >   ```swift
/// >   // compiles for both 64- and 32-bit
/// >   Timecode(.samples(12345678, sampleRate: 48000), at: .fps24)
/// >   ```
/// >
/// >   Library methods that consume `PlatformInt` may have the values wrapped with the type alias:
/// >
/// >   ```swift
/// >   let samples: Int = 12345678
/// >   // compiles for both 64- and 32-bit
/// >   Timecode(.samples(PlatformInt(samples), sampleRate: 48000), at: .fps24)
/// >   ```
/// >
/// >   Library methods/properties that return `PlatformInt` may have their return value safely
/// >   wrapped with `Int64` on both platforms:
/// >
/// >   ```swift
/// >   let platformSamples = timecode.samplesValue(sampleRate: 48000) // PlatformInt
/// >   // compiles for both 64- and 32-bit
/// >   let samples = Int64(platformSamples)
/// >   ```
/// >
/// >   Alternatively, the return value can be handled within conditional compiler blocks:
/// >
/// >   ```swift
/// >   let samples = timecode.samplesValue(sampleRate: 48000) // PlatformInt
/// >   #if _pointerBitWidth(_64)
/// >       // samples will be Int
/// >   #elseif _pointerBitWidth(_32)
/// >       // samples will be Int64
/// >   #else
/// >       #error("Unhandled pointer bit width.")
/// >   #endif
/// >   ```
public typealias PlatformInt = Int

#elseif _pointerBitWidth(_32)

/// Signed integer type that aliases to the appropriate concrete type for the target platform.
/// Resolves to `Int` on 64-bit platforms and `Int64` on 32-bit platforms (including `wasm32`,
/// `armv7k`, and `arm64_32`). Note: Do not use this type alias directly. See the documentation
/// discussion text of this type for details.
///
/// > Note:
/// >
/// > This type is used only as a retroactive solution for providing cross-platform compatibility
/// > to the library in a non-breaking way for existing 64-bit bit platforms, while adding support
/// > for 32-bit platforms that would otherwise narrow `Int` bit-width to 32 bits.
///
/// > Important:
/// >
/// > It is not necessary to use this alias directly unless compiling for both 32- and 64-bit
/// > platforms.
/// >
/// > - If building exclusively for 64-bit platforms, `Int` may be used without any cross-platform
/// >   accommodations needed.
/// >
/// > - If building for 32-bit platforms, `Int64` may be used without any cross-platform
/// >   accommodations needed.
/// >
/// > - If building for both 64- and 32-bit platforms from the same source:
/// >
/// >   Integer literals need no cross-platform accommodations:
/// >
/// >   ```swift
/// >   // compiles for both 64- and 32-bit
/// >   Timecode(.samples(12345678, sampleRate: 48000), at: .fps24)
/// >   ```
/// >
/// >   Library methods that consume `PlatformInt` may have the values wrapped with the type alias:
/// >
/// >   ```swift
/// >   let samples: Int = 12345678
/// >   // compiles for both 64- and 32-bit
/// >   Timecode(.samples(PlatformInt(samples), sampleRate: 48000), at: .fps24)
/// >   ```
/// >
/// >   Library methods/properties that return `PlatformInt` may have their return value safely
/// >   wrapped with `Int64` on both platforms:
/// >
/// >   ```swift
/// >   let platformSamples = timecode.samplesValue(sampleRate: 48000) // PlatformInt
/// >   // compiles for both 64- and 32-bit
/// >   let samples = Int64(platformSamples)
/// >   ```
/// >
/// >   Alternatively, the return value can be handled within conditional compiler blocks:
/// >
/// >   ```swift
/// >   let samples = timecode.samplesValue(sampleRate: 48000) // PlatformInt
/// >   #if _pointerBitWidth(_64)
/// >       // samples will be Int
/// >   #elseif _pointerBitWidth(_32)
/// >       // samples will be Int64
/// >   #else
/// >       #error("Unhandled pointer bit width.")
/// >   #endif
/// >   ```
public typealias PlatformInt = Int64

#else
#error("Unsupported pointer width — PlatformInt needs a mapping for this platform.")
#endif
