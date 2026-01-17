//
//  TimecodeField Paste Policy Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
@testable import SwiftTimecodeUI
import Testing

@Suite struct TimecodeField_Paste_Policy_Tests {
    // MARK: - Test Facilities
    
    private let testFrameRate: TimecodeFrameRate = .fps24
    private let testSubFramesBase: Timecode.SubFramesBase = .max100SubFrames
    
    // Permutations:
    // - Note the columns are in order of evaluation by the `validate()` method.
    // - Entries with combined options (&) are considered the same behavior as far as `validate()` is concerned.
    //
    // PastePolicy              ValidationPolicy  InputStyle                               Timecode.Properties    Valid Values?
    // -----------              ----------------  ---------------------                    ---------------------  -------------
    // preserveLocalProperties  enforceValid      autoAdvance & continuousWithinComponent  (rate / base / limit)  yes / no
    // allowNewProperties       enforceValid      autoAdvance & continuousWithinComponent  (rate / base / limit)  yes / no
    // discardProperties        enforceValid      autoAdvance & continuousWithinComponent  (rate / base / limit)  yes / no
    //
    // preserveLocalProperties  allowInvalid      autoAdvance & continuousWithinComponent  (rate / base / limit)  yes / no
    // allowNewProperties       allowInvalid      autoAdvance & continuousWithinComponent  (rate / base / limit)  yes / no
    // discardProperties        allowInvalid      autoAdvance & continuousWithinComponent  (rate / base / limit)  yes / no
    //
    // preserveLocalProperties  enforceValid      unbounded                                (rate / base / limit)  yes / no
    // allowNewProperties       enforceValid      unbounded                                (rate / base / limit)  yes / no
    // discardProperties        enforceValid      unbounded                                (rate / base / limit)  yes / no
    //
    // preserveLocalProperties  allowInvalid      unbounded                                (rate / base / limit)  yes / no
    // allowNewProperties       allowInvalid      unbounded                                (rate / base / limit)  yes / no
    // discardProperties        allowInvalid      unbounded                                (rate / base / limit)  yes / no
    
    // MARK: - Error Input
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_Error() async {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        // if we pass in an error, the properties and policies don't matter as it will early return
        #expect(
            TimecodeField.validate(
                pasteResult: .failure(Timecode.ValidationError.invalid),
                localTimecodeProperties: timecode.properties, // could be anything
                pastePolicy: .preserveLocalProperties, // could be anything
                validationPolicy: .enforceValid, // could be anything
                inputStyle: .autoAdvance // could be anything
            )
            == nil
        )
    }
    
    // MARK: - preserveLocalProperties / enforceValid / autoAdvance
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_Preserve_EnforceValid_AutoAdvance_SameProperties_ValidValues() async throws {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .preserveLocalProperties,
            validationPolicy: .enforceValid,
            inputStyle: .autoAdvance
        ))
        
        #expect(validated.components == .zero)
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_Preserve_EnforceValid_AutoAdvance_SameProperties_InvalidValues() async {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        #expect(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: timecode.properties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .enforceValid,
                inputStyle: .autoAdvance
            )
            == nil
        )
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_Preserve_EnforceValid_AutoAdvance_DifferentProperties_ValidValues() async {
        // frames value 22 is valid at local 24fps but we're using 48fps which violates preserveLocalProperties policy
        let timecode = Timecode(.components(f: 22), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        #expect(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .enforceValid,
                inputStyle: .autoAdvance
            )
            == nil
        )
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_Preserve_EnforceValid_AutoAdvance_DifferentProperties_InvalidValues() async {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        #expect(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .enforceValid,
                inputStyle: .autoAdvance
            )
            == nil
        )
    }
    
    // MARK: - allowNewProperties / enforceValid / autoAdvance
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_AllowNewProperties_EnforceValid_AutoAdvance_SameProperties_ValidValues() async throws {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .enforceValid,
            inputStyle: .autoAdvance
        ))
        
        #expect(validated.components == .zero)
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_AllowNewProperties_EnforceValid_AutoAdvance_SameProperties_InvalidValues() async {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        #expect(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: timecode.properties,
                pastePolicy: .allowNewProperties,
                validationPolicy: .enforceValid,
                inputStyle: .autoAdvance
            )
            == nil
        )
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_AllowNewProperties_EnforceValid_AutoAdvance_DifferentProperties_ValidValues() async throws {
        // frames value of 46 is invalid at local 24fps but valid at new frame rate of 48fps
        let timecode = Timecode(.components(f: 46), at: .fps48, base: .max80SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .enforceValid,
            inputStyle: .autoAdvance
        ))
        
        #expect(validated.components == .init(f: 46))
        #expect(validated.frameRate == .fps48)
        #expect(validated.subFramesBase == .max80SubFrames)
        #expect(validated.upperLimit == .max100Days)
    }
    
    /// Allow new properties, but the new timecode itself is invalid.
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_AllowNewProperties_EnforceValid_AutoAdvance_DifferentProperties_InvalidValues() async {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        #expect(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .allowNewProperties,
                validationPolicy: .enforceValid,
                inputStyle: .autoAdvance
            )
            == nil
        )
    }
    
    // MARK: - discardProperties / enforceValid / autoAdvance
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_DiscardProperties_EnforceValid_AutoAdvance_SameProperties_ValidValues() async throws {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .discardProperties,
            validationPolicy: .enforceValid,
            inputStyle: .autoAdvance
        ))
        
        #expect(validated.components == .zero)
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_DiscardProperties_EnforceValid_AutoAdvance_SameProperties_InvalidValues() async {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        #expect(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: timecode.properties,
                pastePolicy: .discardProperties,
                validationPolicy: .enforceValid,
                inputStyle: .autoAdvance
            )
            == nil
        )
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_DiscardProperties_EnforceValid_AutoAdvance_DifferentProperties_ValidValues() async {
        let timecode = Timecode(.components(f: 46), at: .fps48, base: .max80SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        // fails because enforceValid rejects new values (which were valid at pasted timecode's frame rate) but are no
        // longer valid at the local frame rate
        #expect(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .discardProperties,
                validationPolicy: .enforceValid,
                inputStyle: .autoAdvance
            )
            == nil
        )
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_DiscardProperties_EnforceValid_AutoAdvance_DifferentProperties_InvalidValues() async {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        #expect(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .discardProperties,
                validationPolicy: .enforceValid,
                inputStyle: .autoAdvance
            )
            == nil
        )
    }
    
    // MARK: - preserveLocalProperties / allowInvalid / autoAdvance
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_Preserve_AllowInvalid_AutoAdvance_SameProperties_ValidValues() async throws {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .preserveLocalProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        #expect(validated.components == .zero)
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_Preserve_AllowInvalid_AutoAdvance_SameProperties_InvalidValues() async {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        #expect(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: timecode.properties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .allowInvalid,
                inputStyle: .autoAdvance
            )
            == timecode
        )
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_Preserve_AllowInvalid_AutoAdvance_DifferentProperties_ValidValues() async {
        // frames value 22 is valid at local 24fps but we're using 48fps which violates preserveLocalProperties policy
        let timecode = Timecode(.components(f: 22), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        #expect(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .allowInvalid,
                inputStyle: .autoAdvance
            )
            == nil
        )
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_Preserve_AllowInvalid_AutoAdvance_DifferentProperties_InvalidValues() async {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        // fails because preserveLocalProperties takes precedence over allowInvalid
        #expect(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .allowInvalid,
                inputStyle: .autoAdvance
            )
            == nil
        )
    }
    
    // MARK: - allowNewProperties / allowInvalid / autoAdvance
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_AllowNewProperties_AllowInvalid_AutoAdvance_SameProperties_ValidValues() async throws {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        #expect(validated.components == .zero)
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_AllowNewProperties_AllowInvalid_AutoAdvance_SameProperties_InvalidValues() async throws {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        #expect(validated.components == .init(f: 30))
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_AllowNewProperties_AllowInvalid_AutoAdvance_DifferentProperties_ValidValues() async throws {
        // frames value of 46 is invalid at local 24fps but valid at new frame rate of 48fps
        let timecode = Timecode(.components(f: 46), at: .fps48, base: .max80SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        #expect(validated.components == .init(f: 46))
        #expect(validated.frameRate == .fps48)
        #expect(validated.subFramesBase == .max80SubFrames)
        #expect(validated.upperLimit == .max100Days)
    }
    
    /// Allow new properties, but the new timecode itself is invalid.
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_AllowNewProperties_AllowInvalid_AutoAdvance_DifferentProperties_InvalidValues() async throws {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        #expect(validated.components == .init(f: 50))
        #expect(validated.frameRate == .fps48)
        #expect(validated.subFramesBase == .max100SubFrames)
        #expect(validated.upperLimit == .max100Days)
    }
    
    // MARK: - discardProperties / allowInvalid / autoAdvance
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_DiscardProperties_AllowInvalid_AutoAdvance_SameProperties_ValidValues() async throws {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        #expect(validated.components == .zero)
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_DiscardProperties_AllowInvalid_AutoAdvance_SameProperties_InvalidValues() async throws {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        #expect(validated.components == .init(f: 30))
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_DiscardProperties_AllowInvalid_AutoAdvance_DifferentProperties_ValidValues() async throws {
        let timecode = Timecode(.components(f: 46), at: .fps48, base: .max80SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        #expect(validated.components == .init(f: 46))
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_DiscardProperties_AllowInvalid_AutoAdvance_DifferentProperties_InvalidValues() async throws {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .autoAdvance
        ))
        
        #expect(validated.components == .init(f: 50))
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    // MARK: - preserveLocalProperties / enforceValid / unbounded
    
    // Note:
    // No need to extensively test `enforceValid` cases since `unbounded` will never be allowed.
    // Just one test is probably enough to confirm `unbounded` isn't allowing invalid values with `enforceValid`.
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_Preserve_EnforceValid_Unbounded_SameProperties_InvalidValuesOutsideDigitBounds() async {
        let timecode = Timecode(.components(f: 234), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        #expect(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: timecode.properties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .enforceValid,
                inputStyle: .unbounded
            )
            == nil
        )
        
    }
    
    // MARK: - preserveLocalProperties / allowInvalid / unbounded
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_Preserve_AllowInvalid_Unbounded_SameProperties_ValidValues() async throws {
        let timecode = Timecode(.components(f: 12), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .preserveLocalProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        #expect(validated.components == .init(f: 12))
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_Preserve_AllowInvalid_Unbounded_SameProperties_InvalidValuesWithinDigitBounds() async throws {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .preserveLocalProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        #expect(validated.components == .init(f: 30))
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_Preserve_AllowInvalid_Unbounded_SameProperties_InvalidValuesOutsideDigitBounds() async throws {
        let timecode = Timecode(.components(f: 234), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .preserveLocalProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        #expect(validated.components == .init(f: 234))
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_Preserve_AllowInvalid_Unbounded_DifferentProperties_ValidValues() async {
        // frames value 22 is valid at local 24fps but we're using 48fps which violates preserveLocalProperties policy
        let timecode = Timecode(.components(f: 22), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        #expect(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .allowInvalid,
                inputStyle: .unbounded
            )
            == nil
        )
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_Preserve_AllowInvalid_Unbounded_DifferentProperties_InvalidValues() async {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        // fails because preserveLocalProperties takes precedence over allowInvalid and unbounded
        #expect(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                localTimecodeProperties: localProperties,
                pastePolicy: .preserveLocalProperties,
                validationPolicy: .allowInvalid,
                inputStyle: .unbounded
            )
            == nil
        )
    }
    
    // MARK: - allowNewProperties / allowInvalid / unbounded
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_AllowNewProperties_AllowInvalid_Unbounded_SameProperties_ValidValues() async throws {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        #expect(validated.components == .zero)
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_AllowNewProperties_AllowInvalid_Unbounded_SameProperties_InvalidValuesWithinDigitBounds() async throws {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        #expect(validated.components == .init(f: 30))
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_AllowNewProperties_AllowInvalid_Unbounded_SameProperties_InvalidValuesOutsideDigitBounds() async throws {
        let timecode = Timecode(.components(f: 234), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        #expect(validated.components == .init(f: 234))
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_AllowNewProperties_AllowInvalid_Unbounded_DifferentProperties_ValidValues() async throws {
        // frames value of 46 is invalid at local 24fps but valid at new frame rate of 48fps
        let timecode = Timecode(.components(f: 46), at: .fps48, base: .max80SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        #expect(validated.components == .init(f: 46))
        #expect(validated.frameRate == .fps48)
        #expect(validated.subFramesBase == .max80SubFrames)
        #expect(validated.upperLimit == .max100Days)
    }
    
    /// Allow new properties, but the new timecode itself is invalid.
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_AllowNewProperties_AllowInvalid_Unbounded_DifferentProperties_InvalidValuesWithinDigitBounds() async throws {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        #expect(validated.components == .init(f: 50))
        #expect(validated.frameRate == .fps48)
        #expect(validated.subFramesBase == .max100SubFrames)
        #expect(validated.upperLimit == .max100Days)
    }
    
    /// Allow new properties, but the new timecode itself is invalid.
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_AllowNewProperties_AllowInvalid_Unbounded_DifferentProperties_InvalidValuesOutsideDigitBounds() async throws {
        let timecode = Timecode(.components(f: 234), at: .fps48, base: .max100SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .allowNewProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        #expect(validated.components == .init(f: 234))
        #expect(validated.frameRate == .fps48)
        #expect(validated.subFramesBase == .max100SubFrames)
        #expect(validated.upperLimit == .max100Days)
    }
    
    // MARK: - discardProperties / allowInvalid / unbounded
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_DiscardProperties_AllowInvalid_Unbounded_SameProperties_ValidValues() async throws {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        #expect(validated.components == .zero)
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_DiscardProperties_AllowInvalid_Unbounded_SameProperties_InvalidValuesWithinDigitBounds() async throws {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        #expect(validated.components == .init(f: 30))
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_DiscardProperties_AllowInvalid_Unbounded_SameProperties_InvalidValuesOutsideDigitBounds() async throws {
        let timecode = Timecode(.components(f: 234), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: timecode.properties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        #expect(validated.components == .init(f: 234))
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_DiscardProperties_AllowInvalid_Unbounded_DifferentProperties_ValidValues() async throws {
        let timecode = Timecode(.components(f: 46), at: .fps48, base: .max80SubFrames, limit: .max100Days, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        #expect(validated.components == .init(f: 46))
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_DiscardProperties_AllowInvalid_Unbounded_DifferentProperties_InvalidValuesWithinDigitBounds() async throws {
        let timecode = Timecode(.components(f: 50), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        #expect(validated.components == .init(f: 50))
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func validatePasteResult_DiscardProperties_AllowInvalid_Unbounded_DifferentProperties_InvalidValuesOutsideDigitBounds() async throws {
        let timecode = Timecode(.components(f: 234), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        let localProperties = Timecode.Properties(rate: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        let validated = try #require(TimecodeField.validate(
            pasteResult: .success(timecode),
            localTimecodeProperties: localProperties,
            pastePolicy: .discardProperties,
            validationPolicy: .allowInvalid,
            inputStyle: .unbounded
        ))
        
        #expect(validated.components == .init(f: 234))
        #expect(validated.frameRate == testFrameRate)
        #expect(validated.subFramesBase == testSubFramesBase)
        #expect(validated.upperLimit == .max24Hours)
    }
}

#endif
