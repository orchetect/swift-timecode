//
//  Fraction Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2026 Steffan Andrews • Licensed under MIT License
//

@testable import SwiftTimecodeCore
import Testing

@Suite
struct Fraction_Tests {
    @Test
    func absolute() {
        #expect(Fraction(2, 4).abs() == Fraction(2, 4))
        #expect(Fraction(-2, 4).abs() == Fraction(2, 4))
        #expect(Fraction(2, -4).abs() == Fraction(2, 4))
        #expect(Fraction(-2, -4).abs() == Fraction(2, 4))
    }

    @Test
    func isNegative() {
        #expect(!Fraction(2, 4).isNegative)
        #expect(Fraction(-2, 4).isNegative)
        #expect(Fraction(2, -4).isNegative)
        #expect(!Fraction(-2, -4).isNegative)
    }

    @Test
    func isWholeInteger() {
        #expect(Fraction(4, 2).isWholeInteger) // == 2.0
        #expect(Fraction(2, 1).isWholeInteger) // == 2.0

        #expect(!Fraction(1, 2).isWholeInteger) // == 0.5
        #expect(!Fraction(2, 4).isWholeInteger) // == 0.5

        #expect(Fraction(0, 1).isWholeInteger) // == 0.0
    }

    @Test
    func negated() {
        #expect(Fraction(2, 4).negated() == Fraction(-2, 4))
        #expect(Fraction(-2, 4).negated() == Fraction(2, 4))
        #expect(Fraction(2, -4).negated() == Fraction(-2, -4))
        #expect(Fraction(-2, -4).negated() == Fraction(2, -4))
    }

    @Test
    func isEqual() {
        #expect(Fraction(2, 4).isEqual(to: Fraction(2, 4)))
        #expect(Fraction(2, 4).isEqual(to: Fraction(1, 2)))
        #expect(Fraction(-1, -2).isEqual(to: Fraction(1, 2)))
    }

    @Test
    func comparable() {
        #expect(!(Fraction(2, 4) < Fraction(2, 4)))
        #expect(!(Fraction(2, 4) > Fraction(2, 4)))

        #expect(!(Fraction(1, 2) < Fraction(2, 4)))
        #expect(!(Fraction(1, 2) > Fraction(2, 4)))

        #expect(!(Fraction(2, 4) < Fraction(1, 2)))
        #expect(!(Fraction(2, 4) > Fraction(1, 2)))

        #expect(Fraction(1, 10) < Fraction(2, 10))
        #expect(Fraction(2, 10) > Fraction(1, 10))
    }

    @Test
    func mathAdd() {
        #expect(Fraction(1, 2) + Fraction(1, 4) == Fraction(3, 4))
        #expect(Fraction(2, 4) + Fraction(1, 4) == Fraction(3, 4))

        #expect(Fraction(-1, 2) + Fraction(1, 4) == Fraction(-1, 4))
        #expect(Fraction(-1, 2) + Fraction(-1, 4) == Fraction(-3, 4))

        #expect(Fraction(750, 1900) + Fraction(8000, 3800) == Fraction(5, 2))
    }

    @Test
    func mathSubtract() {
        #expect(Fraction(3, 4) - Fraction(1, 2) == Fraction(1, 4))
        #expect(Fraction(3, 4) - Fraction(2, 4) == Fraction(1, 4))

        #expect(Fraction(-3, 4) - Fraction(2, 4) == Fraction(-5, 4))
        #expect(Fraction(-3, 4) - Fraction(-2, 4) == Fraction(-1, 4))

        #expect(Fraction(8000, 3800) - Fraction(100, 1900) == Fraction(39, 19))
    }

    @Test
    func mathMultiply() {
        #expect(Fraction(1, 4) * Fraction(2, 8) == Fraction(1, 16))
        #expect(Fraction(1, 4) * Fraction(8, 32) == Fraction(1, 16))
        #expect(Fraction(3, 4) * Fraction(1, 2) == Fraction(3, 8))

        #expect(Fraction(-3, 4) * Fraction(1, 2) == Fraction(-3, 8))
        #expect(Fraction(-3, 4) * Fraction(-1, 2) == Fraction(3, 8))

        #expect(Fraction(900, 1800) * Fraction(9500, 3800) == Fraction(5, 4))
    }

    @Test
    func mathDivide() {
        #expect(Fraction(1, 16) / Fraction(2, 8) == Fraction(1, 4))
        #expect(Fraction(8, 32) / Fraction(1, 4) == Fraction(1, 1))

        #expect(Fraction(-1, 16) / Fraction(2, 8) == Fraction(-1, 4))
        #expect(Fraction(-1, 16) / Fraction(-2, 8) == Fraction(1, 4))
        #expect(Fraction(1, 16) / Fraction(-2, 8) == Fraction(-1, 4))

        #expect(Fraction(5, 4) / Fraction(900, 1800) == Fraction(9500, 3800))
    }

    @Test
    func fractionInitReducing() {
        let frac = Fraction(reducing: 4, 2)
        #expect(frac == Fraction(2, 1))
        #expect(frac.isReduced)
    }

    @Test
    func fractionReduced() {
        let frac = Fraction(4, 2)
        #expect(frac.numerator == 4)
        #expect(frac.denominator == 2)
        #expect(!frac.isReduced)

        let reduced = frac.reduced()
        #expect(reduced == Fraction(2, 1))
        #expect(reduced.isReduced)

        #expect(Fraction(2, 1).isReduced)
    }

    @Test
    func fractionReduced_NegativeValues_A() {
        let frac = Fraction(-4, 2)
        #expect(frac.numerator == -4)
        #expect(frac.denominator == 2)
        #expect(!frac.isReduced)

        let reduced = frac.reduced() // also normalizes signs
        #expect(reduced == Fraction(-2, 1))
        #expect(reduced.isReduced)
    }

    @Test
    func fractionReduced_NegativeValues_B() {
        let frac = Fraction(4, -2)
        #expect(frac.numerator == 4)
        #expect(frac.denominator == -2)
        #expect(!frac.isReduced)

        let reduced = frac.reduced() // also normalizes signs
        #expect(reduced == Fraction(-2, 1))
        #expect(reduced.isReduced)
    }

    @Test
    func fractionReduced_NegativeValues_C() {
        let frac = Fraction(-4, -2)
        #expect(frac.numerator == -4)
        #expect(frac.denominator == -2)
        #expect(!frac.isReduced)

        let reduced = frac.reduced() // also normalizes signs
        #expect(reduced == Fraction(2, 1))
        #expect(reduced.isReduced)
    }

    @Test
    func fractionReduced_NegativeValues_D() {
        let frac = Fraction(-1, 2)
        #expect(frac.numerator == -1)
        #expect(frac.denominator == 2)
        #expect(frac.isReduced)

        let reduced = frac.reduced() // also normalizes signs
        #expect(reduced == Fraction(-1, 2))
        #expect(reduced.isReduced)
    }

    @Test
    func init_Double() {
        #expect(Fraction(double: 2.0) == Fraction(2, 1))
        #expect(Fraction(double: 0.5) == Fraction(1, 2))

        // high precision
        #expect(
            Fraction(double: 30000 / 1001, decimalPrecision: 18)
                == Fraction(2_926_760_739_260_739, 97_656_250_000_000)
        )
        #expect(
            Fraction(double: 30000 / 1001, decimalPrecision: 18).doubleValue
                == 29.970029970029966
        )

        // edge case: algorithm can work with up to 18 places of precision
        #expect(
            Fraction(double: 9.999_999_999_999_999_99, decimalPrecision: 50).doubleValue
                == 9.999_999_999_999_999_999
        )
        #expect(
            Fraction(double: 9.999_999_999_999_999_99, decimalPrecision: 50).doubleValue
                == 10.0
        )

        // edge case: a really high precision number.
        // it will clamp number of decimal places internally.
        #expect(Fraction(double: 30000 / 1001, decimalPrecision: 50).doubleValue == 29.970029970029966)

        // edge case: a negative precision number.
        // it will clamp number of decimal places internally.
        #expect(Fraction(double: 30000 / 1001, decimalPrecision: -2).doubleValue == 29.0)
    }

    @Test
    func init_Double_NegativeValues() {
        #expect(Fraction(double: -2.0) == Fraction(-2, 1))
        #expect(Fraction(double: -0.5) == Fraction(-1, 2))

        // high precision
        #expect(
            Fraction(double: -(30000 / 1001), decimalPrecision: 18)
                == Fraction(-2_926_760_739_260_739, 97_656_250_000_000)
        )
        #expect(
            Fraction(double: -(30000 / 1001), decimalPrecision: 18).doubleValue
                == -29.970029970029966
        )

        // edge case: a really high precision number.
        // it will clamp number of decimal places internally.
        #expect(Fraction(double: -30000 / 1001, decimalPrecision: 50).doubleValue == -29.970029970029966)

        // edge case: a negative precision number.
        // it will clamp number of decimal places internally.
        #expect(Fraction(double: -30000 / 1001, decimalPrecision: -2).doubleValue == -29.0)
    }

    @Test
    func doubleValue() {
        #expect(Fraction(4, 2).doubleValue == 2.0)
        #expect(Fraction(2, 1).doubleValue == 2.0)

        #expect(Fraction(2, 4).doubleValue == 0.5)
        #expect(Fraction(1, 2).doubleValue == 0.5)
    }

    @Test
    func doubleValue_NegativeValues() {
        #expect(Fraction(-4, 2).doubleValue == -2.0)
        #expect(Fraction(-2, 1).doubleValue == -2.0)

        #expect(Fraction(-2, 4).doubleValue == -0.5)
        #expect(Fraction(-1, 2).doubleValue == -0.5)
    }

    @Test
    func negativeValues() {
        #expect(Fraction(-1, 5).doubleValue == -0.2)
        #expect(Fraction(1, -5).doubleValue == -0.2)
        #expect(Fraction(-1, -5).doubleValue == 0.2)
    }

    @Test
    func normalized() {
        #expect(Fraction(-1, 5).normalized() == Fraction(-1, 5))
        #expect(Fraction(1, -5).normalized() == Fraction(-1, 5))
        #expect(Fraction(-1, -5).normalized() == Fraction(1, 5))
    }

    @Test
    func edgeCases() {
        // test that division by zero crashes don't occur etc.

        #expect(Fraction(1, 0).doubleValue == .infinity)
        #expect(Fraction(0, 0).doubleValue.isNaN)
        #expect(Fraction(0, 1).doubleValue == 0.0)

        #expect(Fraction(-1, 0).doubleValue == -.infinity)
        #expect(Fraction(0, 0).doubleValue.isNaN)
        #expect(Fraction(0, -1).doubleValue == 0.0)
    }

    // MARK: FCPXML Encoding

    @Test
    func init_fcpxmlString() {
        #expect(Fraction(fcpxmlString: "0s") == Fraction(0, 1))
        #expect(Fraction(fcpxmlString: "4s") == Fraction(4, 1))

        #expect(Fraction(fcpxmlString: "4/2s") == Fraction(2, 1))
        #expect(Fraction(fcpxmlString: "2/1s") == Fraction(2, 1))
    }

    @Test
    func init_fcpxmlString_NegativeValues() {
        #expect(Fraction(fcpxmlString: "-0s") == Fraction(-0, 1))
        #expect(Fraction(fcpxmlString: "-4s") == Fraction(-4, 1))

        #expect(Fraction(fcpxmlString: "-4/2s") == Fraction(-2, 1))
        #expect(Fraction(fcpxmlString: "-2/1s") == Fraction(-2, 1))

        // we would like to ensure the fraction does not reduce for FCPXML.
        // it's not a requirement, but makes comparisons easier with the XML.
        #expect(Fraction(fcpxmlString: "4/2s")?.numerator == 4)
        #expect(Fraction(fcpxmlString: "4/2s")?.denominator == 2)
    }

    @Test
    func fcpxmlString() {
        #expect(Fraction(0, 1).fcpxmlStringValue == "0s")
        #expect(Fraction(4, 1).fcpxmlStringValue == "4s")

        #expect(Fraction(4, 2).fcpxmlStringValue == "2s")
        #expect(Fraction(2, 1).fcpxmlStringValue == "2s")

        // we would like to ensure the fraction does not reduce for FCPXML.
        // it's not a requirement, but makes comparisons easier with the XML.
        #expect(Fraction(2, 4).fcpxmlStringValue == "2/4s")
        #expect(Fraction(1, 2).fcpxmlStringValue == "1/2s")
    }

    @Test
    func fcpxmlString_NegativeValues() {
        #expect(Fraction(-0, 1).fcpxmlStringValue == "0s") // zero will remove negative sign
        #expect(Fraction(-4, 1).fcpxmlStringValue == "-4s")

        #expect(Fraction(-4, 2).fcpxmlStringValue == "-2s")
        #expect(Fraction(-2, 1).fcpxmlStringValue == "-2s")

        // we would like to ensure the fraction does not reduce for FCPXML.
        // it's not a requirement, but makes comparisons easier with the XML.
        #expect(Fraction(-2, 4).fcpxmlStringValue == "-2/4s")
        #expect(Fraction(-1, 2).fcpxmlStringValue == "-1/2s")
    }
}
