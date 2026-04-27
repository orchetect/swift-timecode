/// ----------------------------------------------
/// ----------------------------------------------
/// Extensions/Darwin/FloatingPoint and Darwin.swift
///
/// Borrowed from swift-extensions 2.1.7 under MIT license.
/// https://github.com/orchetect/swift-extensions
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#endif

// MARK: - ceiling / floor

extension FloatingPoint {
    /// Same as `ceil()`
    /// (Functional convenience method)
    @_disfavoredOverload
    package var ceiling: Self {
        #if canImport(Darwin)
        Darwin.ceil(self)
        #elseif canImport(Glibc)
        Glibc.ceil(self)
        #elseif canImport(Musl)
        Musl.ceil(self)
        #endif
    }

    /// Same as `floor()`
    /// (Functional convenience method)
    @_disfavoredOverload
    package var floor: Self {
        #if canImport(Darwin)
        Darwin.floor(self)
        #elseif canImport(Glibc)
        Glibc.floor(self)
        #elseif canImport(Musl)
        Musl.floor(self)
        #endif
    }
}

// MARK: - FloatingPointPowerComputable

// MARK: - .power()

extension Double: FloatingPointPowerComputable {
    /// Same as `pow()`
    /// (Functional convenience method)
    @_disfavoredOverload
    package func power(_ exponent: Double) -> Double {
        pow(self, exponent)
    }
}

extension Float: FloatingPointPowerComputable {
    /// Same as `powf()`
    /// (Functional convenience method)
    @_disfavoredOverload
    package func power(_ exponent: Float) -> Float {
        powf(self, exponent)
    }
}

#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
extension Float80: FloatingPointPowerComputable {
    /// Same as `powl()`
    /// (Functional convenience method)
    @_disfavoredOverload
    package func power(_ exponent: Float80) -> Float80 {
        powl(self, exponent)
    }
}
#endif
