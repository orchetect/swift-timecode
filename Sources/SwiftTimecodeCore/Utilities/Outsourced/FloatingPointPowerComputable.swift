/// ----------------------------------------------
/// ----------------------------------------------
/// Protocols/Protocols.swift
///
/// Borrowed from swift-extensions 2.1.7 under MIT license.
/// https://github.com/orchetect/swift-extensions
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

// MARK: - FloatingPointPowerComputable

/// Protocol allowing implementation of convenience method `.power(_ exponent:)`
/// - warning: (Internal use. Do not use this protocol.)
package protocol FloatingPointPowerComputable {
    func power(_ exponent: Self) -> Self
}
