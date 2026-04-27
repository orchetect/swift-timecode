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

#if canImport(Foundation)

import Foundation

// MARK: - Digit Places

extension Double {
    /// Returns the number of digit places of the ``integral`` portion (left of the decimal).
    package var integralDigitPlaces: Int {
        Decimal(self).integralDigitPlaces
    }

    /// Returns the number of digit places of the ``fraction`` portion (right of the decimal).
    package var fractionDigitPlaces: Int {
        Decimal(self).fractionDigitPlaces
    }
}

#endif
