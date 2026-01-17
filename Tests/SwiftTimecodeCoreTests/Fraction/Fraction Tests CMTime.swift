//
//  Fraction Tests CMTime.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(CoreMedia)

import CoreMedia
import SwiftTimecodeCore
import Testing

@Suite struct Fraction_CMTime_Tests {
    @Test
    func fraction_init_CMTime() async {
        #expect(
            Fraction(CMTime(value: 3600, timescale: 1))
                == Fraction(3600, 1)
        )
        
        #expect(
            Fraction(CMTime(value: -3600, timescale: 1))
                == Fraction(-3600, 1)
        )
    }
    
    @Test
    func fraction_init_CMTime_EdgeCases() async {
        #expect(
            Fraction(CMTime.indefinite)
                == Fraction(0, 1)
        )
        
        #expect(
            Fraction(CMTime.negativeInfinity)
                == Fraction(0, 1)
        )
        
        #expect(
            Fraction(CMTime.positiveInfinity)
                == Fraction(0, 1)
        )
    }
    
    @Test
    func fraction_cmTimeValue() async {
        #expect(
            Fraction(3600, 1).cmTimeValue
                == CMTime(value: 3600, timescale: 1)
        )
        
        #expect(
            Fraction(-3600, 1).cmTimeValue
                == CMTime(value: -3600, timescale: 1)
        )
    }
    
    @Test
    func cmTime_init_Fraction() async {
        #expect(
            CMTime(Fraction(3600, 1))
                == CMTime(value: 3600, timescale: 1)
        )
        
        #expect(
            CMTime(Fraction(-3600, 1))
                == CMTime(value: -3600, timescale: 1)
        )
    }
    
    @Test
    func cmTime_fractionValue() async {
        #expect(
            CMTime(value: 3600, timescale: 1).fractionValue
                == Fraction(3600, 1)
        )
        
        #expect(
            CMTime(value: -3600, timescale: 1).fractionValue
                == Fraction(-3600, 1)
        )
    }
}

#endif
