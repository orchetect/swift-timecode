//
//  TimecodeTransformer Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import Testing

@Suite
struct TimecodeTransformer_Tests {
    @Test
    func none() throws {
        // .none

        let transformer = TimecodeTransformer(.none)

        #expect(
            try transformer.transform(Timecode(.components(h: 1), at: .fps24))
                == Timecode(.components(h: 01, m: 00, s: 00, f: 00), at: .fps24)
        )
    }

    @Test
    func offset() throws {
        // .offset()

        let deltaTC = try Timecode(.components(m: 1), at: .fps24)
        let delta = TimecodeInterval(deltaTC, .plus)

        var transformer = TimecodeTransformer(.offset(by: delta))

        // disabled

        transformer.enabled = false

        #expect(
            try transformer.transform(Timecode(.components(h: 1), at: .fps24))
                == Timecode(.components(h: 01, m: 00, s: 00, f: 00), at: .fps24)
        )

        // enabled

        transformer.enabled = true

        #expect(
            try transformer.transform(Timecode(.components(h: 1), at: .fps24))
                == Timecode(.components(h: 01, m: 01, s: 00, f: 00), at: .fps24)
        )
    }

    @Test
    func custom() throws {
        // .custom()

        let transformer = TimecodeTransformer(.custom { // inputTC -> Timecode in
            $0.adding(Timecode.Components(m: 1), by: .wrapping)
        })

        #expect(
            try transformer.transform(Timecode(.components(h: 1), at: .fps24))
                == Timecode(.components(h: 01, m: 01, s: 00, f: 00), at: .fps24)
        )
    }

    @Test
    func empty() throws {
        // array init allows empty transform array
        let transformer = TimecodeTransformer([])

        #expect(
            try transformer.transform(Timecode(.components(h: 1), at: .fps24))
                == Timecode(.components(h: 01, m: 00, s: 00, f: 00), at: .fps24)
        )
    }

    @Test
    func multiple_Offsets() throws {
        // .offset(by:)

        let deltaTC1 = try Timecode(.components(m: 1), at: .fps24)
        let delta1 = TimecodeInterval(deltaTC1, .plus)

        let deltaTC2 = try Timecode(.components(s: 1), at: .fps24)
        let delta2 = TimecodeInterval(deltaTC2, .minus)

        let transformer = TimecodeTransformer([.offset(by: delta1), .offset(by: delta2)])

        #expect(
            try transformer.transform(Timecode(.components(h: 1), at: .fps24))
                == Timecode(.components(h: 01, m: 00, s: 59, f: 00), at: .fps24)
        )
    }

    @Test
    func shorthand() {
        let delta = Timecode(.zero, at: .fps24)
        _ = TimecodeTransformer(.offset(by: .positive(delta)))
    }
}
