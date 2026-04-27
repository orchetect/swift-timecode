/// ----------------------------------------------
/// ----------------------------------------------
/// Extensions/Swift/FloatingPoint.swift
///
/// Borrowed from swift-extensions 2.1.7 under MIT license.
/// https://github.com/orchetect/swift-extensions
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

// MARK: - .truncated() / .rounded

extension FloatingPoint where Self: FloatingPointPowerComputable {
    /// Rounds to `decimalPlaces` number of decimal places using rounding `rule`.
    ///
    /// If `decimalPlaces` <= 0, trunc(self) is returned.
    @_disfavoredOverload
    package func rounded(
        _ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
        decimalPlaces: Int
    ) -> Self {
        if decimalPlaces < 1 {
            return rounded(rule)
        }

        let offset = Self(10).power(Self(decimalPlaces))

        return (self * offset).rounded(rule) / offset
    }

    /// Replaces this value by rounding it to `decimalPlaces` number of decimal places using rounding `rule`.
    ///
    /// If `decimalPlaces` <= 0, `trunc(self)` is used.
    @_disfavoredOverload
    package mutating func round(
        _ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
        decimalPlaces: Int
    ) {
        self = rounded(rule, decimalPlaces: decimalPlaces)
    }
}

// MARK: - Truncated

extension FloatingPoint where Self: FloatingPointPowerComputable {
    /// Replaces this value by truncating it to `decimalPlaces` number of decimal places.
    ///
    /// If `decimalPlaces <= 0`, then `self.rounded(.towardZero)` is returned.
    @_disfavoredOverload
    package mutating func truncate(decimalPlaces: Int) {
        self = truncated(decimalPlaces: decimalPlaces)
    }
    
    /// Truncates decimal places to `decimalPlaces` number of decimal places.
    ///
    /// If `decimalPlaces <= 0`, then `self.rounded(.towardZero)` is returned.
    @_disfavoredOverload
    package func truncated(decimalPlaces: Int) -> Self {
        if decimalPlaces < 1 {
            return rounded(.towardZero)
        }
        
        let offset = Self(10).power(Self(decimalPlaces))
        return (self * offset).rounded(.towardZero) / offset
    }
}

extension FloatingPoint {
    /// Similar to `Int.quotientAndRemainder(dividingBy:)` from the Swift standard library.
    @_disfavoredOverload
    package func quotientAndRemainder(dividingBy rhs: Self) -> (quotient: Self, remainder: Self) {
        let calculation = self / rhs
        let integral = calculation.rounded(.towardZero)
        let fraction = self - (integral * rhs)
        return (quotient: integral, remainder: fraction)
    }
    
    /// Returns both integral part and fractional part.
    ///
    /// - Note: This method is more computationally efficient than calling both `integral` and
    ///   `fraction` properties separately unless you only require one or the other.
    ///
    /// This method can result in a non-trivial loss of precision for the fractional part.
    @inlinable @_disfavoredOverload
    package var integralAndFraction: (integral: Self, fraction: Self) {
        let integral = rounded(.towardZero)
        let fraction = self - integral
        return (integral: integral, fraction: fraction)
    }
    
    /// Returns the integral part (digits before the decimal point).
    @inlinable @_disfavoredOverload
    package var integral: Self {
        integralAndFraction.integral
    }
    
    /// Returns the fractional part (digits after the decimal point).
    ///
    /// - Note: this method can result in a non-trivial loss of precision for the fractional part.
    @inlinable @_disfavoredOverload
    package var fraction: Self {
        integralAndFraction.fraction
    }
}
