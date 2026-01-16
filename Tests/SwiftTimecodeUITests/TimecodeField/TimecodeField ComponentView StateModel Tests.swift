//
//  TimecodeField ComponentView StateModel Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
@testable import SwiftTimecodeUI
import Testing

@Suite struct TimecodeField_ComponentView_StateModel_Tests {
    // MARK: - Test Facilities
    
    private var testFrameRate: TimecodeFrameRate { .fps24 }
    private var testSubFramesBase: Timecode.SubFramesBase { .max100SubFrames }
    private var testUpperLimit: Timecode.UpperLimit { .max24Hours }
    
    /// Returns a new component state instance using the timecode properties constants.
    private func stateModelFactory(
        component: Timecode.Component,
        rate: TimecodeFrameRate? = nil,
        base: Timecode.SubFramesBase? = nil,
        limit: Timecode.UpperLimit? = nil,
        inputStyle: TimecodeField.InputStyle,
        policy: TimecodeField.ValidationPolicy,
        initialValue: Int
    ) -> MockStateModel {
        MockStateModel(
            component: component,
            rate: rate ?? testFrameRate,
            base: base ?? testSubFramesBase,
            limit: limit ?? testUpperLimit,
            inputStyle: inputStyle,
            policy: policy,
            initialValue: initialValue
        )
    }
    
    // MARK: - autoAdvance / enforceValid
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Hours_00() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.num0) == .init(.handled, .focusNextComponent))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Hours_01() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.num1) == .init(.handled, .focusNextComponent))
        #expect(state.value == 1)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Hours_12() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.num2) == .init(.handled, .focusNextComponent))
        #expect(state.value == 12)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Hours_a12() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.a) == .init(.ignored, rejection: .undefinedKey))
        #expect(state.value == 0)
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.num2) == .init(.handled, .focusNextComponent))
        #expect(state.value == 12)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Hours_1a2() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.a) == .init(.ignored, rejection: .undefinedKey))
        #expect(state.value == 1)
        
        #expect(state.press(.num2) == .init(.handled, .focusNextComponent))
        #expect(state.value == 12)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Hours_293() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num2) == .init(.handled))
        #expect(state.value == 2)
        
        #expect(state.press(.num9) == .init(.handled, rejection: .invalid))
        #expect(state.value == 2)
        
        #expect(state.press(.num3) == .init(.handled, .focusNextComponent))
        #expect(state.value == 23)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Hours_period() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.period) == .init(.handled, .focusNextComponent))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Hours_1period() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.period) == .init(.handled, .focusNextComponent))
        #expect(state.value == 1)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Hours_colon() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.colon) == .init(.handled, .focusNextComponent))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Hours_1colon() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.colon) == .init(.handled, .focusNextComponent))
        #expect(state.value == 1)
    }
    
    // MARK: - continuousWithinComponent / enforceValid
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_EnforceValid_Hours_00() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_EnforceValid_Hours_012200() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.num2) == .init(.handled))
        #expect(state.value == 12)
        
        #expect(state.press(.num2) == .init(.handled))
        #expect(state.value == 22)
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 20)
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_EnforceValid_Hours_a12a3() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.a) == .init(.ignored, rejection: .undefinedKey))
        #expect(state.value == 0)
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.num2) == .init(.handled))
        #expect(state.value == 12)
        
        #expect(state.press(.a) == .init(.ignored, rejection: .undefinedKey))
        #expect(state.value == 12)
        
        #expect(state.press(.num3) == .init(.handled))
        #expect(state.value == 23)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_EnforceValid_Hours_1a2() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.a) == .init(.ignored, rejection: .undefinedKey))
        #expect(state.value == 1)
        
        #expect(state.press(.num2) == .init(.handled))
        #expect(state.value == 12)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_EnforceValid_Hours_293() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num2) == .init(.handled))
        #expect(state.value == 2)
        
        #expect(state.press(.num9) == .init(.handled, rejection: .invalid))
        #expect(state.value == 2)
        
        #expect(state.press(.num3) == .init(.handled))
        #expect(state.value == 23)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_EnforceValid_Hours_period() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.period) == .init(.handled, .focusNextComponent))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_EnforceValid_Hours_1period() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.period) == .init(.handled, .focusNextComponent))
        #expect(state.value == 1)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_EnforceValid_Hours_colon() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.colon) == .init(.handled, .focusNextComponent))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_EnforceValid_Hours_1colon() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.colon) == .init(.handled, .focusNextComponent))
        #expect(state.value == 1)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_EnforceValid_Hours_123colon() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.num2) == .init(.handled))
        #expect(state.value == 12)
        
        #expect(state.press(.num3) == .init(.handled))
        #expect(state.value == 23)
        
        #expect(state.press(.colon) == .init(.handled, .focusNextComponent))
        #expect(state.value == 23)
    }
    
    // MARK: - autoAdvance / allowInvalid
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_AllowInvalid_Hours_00() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.num0) == .init(.handled, .focusNextComponent))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_AllowInvalid_Hours_01() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.num1) == .init(.handled, .focusNextComponent))
        #expect(state.value == 1)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_AllowInvalid_Hours_12() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.num2) == .init(.handled, .focusNextComponent))
        #expect(state.value == 12)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_AllowInvalid_Hours_a12() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.a) == .init(.ignored, rejection: .undefinedKey))
        #expect(state.value == 0)
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.num2) == .init(.handled, .focusNextComponent))
        #expect(state.value == 12)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_AllowInvalid_Hours_1a2() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.a) == .init(.ignored, rejection: .undefinedKey))
        #expect(state.value == 1)
        
        #expect(state.press(.num2) == .init(.handled, .focusNextComponent))
        #expect(state.value == 12)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_AllowInvalid_Hours_29() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.num2) == .init(.handled))
        #expect(state.value == 2)
        
        #expect(state.press(.num9) == .init(.handled, .focusNextComponent))
        #expect(state.value == 29)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_AllowInvalid_Hours_period() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.period) == .init(.handled, .focusNextComponent))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_AllowInvalid_Hours_1period() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.period) == .init(.handled, .focusNextComponent))
        #expect(state.value == 1)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_AllowInvalid_Hours_colon() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.colon) == .init(.handled, .focusNextComponent))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_AllowInvalid_Hours_1colon() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.colon) == .init(.handled, .focusNextComponent))
        #expect(state.value == 1)
    }
    
    // MARK: - continuousWithinComponent / allowInvalid
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_AllowInvalid_Hours_00() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_AllowInvalid_Hours_01228900() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.num2) == .init(.handled))
        #expect(state.value == 12)
        
        #expect(state.press(.num2) == .init(.handled))
        #expect(state.value == 22)
        
        #expect(state.press(.num8) == .init(.handled))
        #expect(state.value == 28)
        
        #expect(state.press(.num9) == .init(.handled))
        #expect(state.value == 89)
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 90)
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_AllowInvalid_Hours_a12a3() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.a) == .init(.ignored, rejection: .undefinedKey))
        #expect(state.value == 0)
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.num2) == .init(.handled))
        #expect(state.value == 12)
        
        #expect(state.press(.a) == .init(.ignored, rejection: .undefinedKey))
        #expect(state.value == 12)
        
        #expect(state.press(.num3) == .init(.handled))
        #expect(state.value == 23)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_AllowInvalid_Hours_1a2() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.a) == .init(.ignored, rejection: .undefinedKey))
        #expect(state.value == 1)
        
        #expect(state.press(.num2) == .init(.handled))
        #expect(state.value == 12)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_AllowInvalid_Hours_period() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.period) == .init(.handled, .focusNextComponent))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_AllowInvalid_Hours_1period() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.period) == .init(.handled, .focusNextComponent))
        #expect(state.value == 1)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_AllowInvalid_Hours_colon() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.colon) == .init(.handled, .focusNextComponent))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_AllowInvalid_Hours_1colon() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.colon) == .init(.handled, .focusNextComponent))
        #expect(state.value == 1)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_AllowInvalid_Hours_123colon() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.num2) == .init(.handled))
        #expect(state.value == 12)
        
        #expect(state.press(.num3) == .init(.handled))
        #expect(state.value == 23)
        
        #expect(state.press(.colon) == .init(.handled, .focusNextComponent))
        #expect(state.value == 23)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_AllowInvalid_Hours_98colon() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.num9) == .init(.handled))
        #expect(state.value == 9)
        
        #expect(state.press(.num8) == .init(.handled))
        #expect(state.value == 98)
        
        #expect(state.press(.colon) == .init(.handled, .focusNextComponent))
        #expect(state.value == 98)
    }
    
    // MARK: - Up/Down Arrow Keys
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Hours_UpDownArrows() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.upArrow) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.upArrow) == .init(.handled))
        #expect(state.value == 2)
        
        #expect(state.press(.upArrow) == .init(.handled))
        #expect(state.value == 3)
        
        #expect(state.press(.downArrow) == .init(.handled))
        #expect(state.value == 2)
        
        #expect(state.press(.downArrow) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.downArrow) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.downArrow) == .init(.handled))
        #expect(state.value == 23)
        
        #expect(state.press(.downArrow) == .init(.handled))
        #expect(state.value == 22)
        
        #expect(state.press(.upArrow) == .init(.handled))
        #expect(state.value == 23)
        
        #expect(state.press(.upArrow) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.upArrow) == .init(.handled))
        #expect(state.value == 1)
    }
    
    /// Even when allowing invalid values, increment/decrement should wrap around valid values.
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_AllowInvalid_Hours_UpDownArrows() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.upArrow) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.upArrow) == .init(.handled))
        #expect(state.value == 2)
        
        #expect(state.press(.upArrow) == .init(.handled))
        #expect(state.value == 3)
        
        #expect(state.press(.downArrow) == .init(.handled))
        #expect(state.value == 2)
        
        #expect(state.press(.downArrow) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.downArrow) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.downArrow) == .init(.handled))
        #expect(state.value == 23)
        
        #expect(state.press(.downArrow) == .init(.handled))
        #expect(state.value == 22)
        
        #expect(state.press(.upArrow) == .init(.handled))
        #expect(state.value == 23)
        
        #expect(state.press(.upArrow) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.upArrow) == .init(.handled))
        #expect(state.value == 1)
    }
    
    // MARK: - Left/Right Arrow Keys
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_Days_LeftArrow() async {
        let state = stateModelFactory(
            component: .days,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.leftArrow) == .init(.handled, .focusPreviousComponent))
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_Days_RightArrow() async {
        let state = stateModelFactory(
            component: .days,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.rightArrow) == .init(.handled, .focusNextComponent))
    }
    
    // MARK: - Return/Escape Keys
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_Days_Return() async {
        let state = stateModelFactory(
            component: .days,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.return) == .init(.performReturnAction))
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_Days_Escape() async {
        let state = stateModelFactory(
            component: .days,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        #expect(state.press(.escape) == .init(.performEscapeAction))
    }
    
    // MARK: - Edge Case: 3-digit frame rate
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Frames_000() async {
        let state = stateModelFactory(
            component: .frames,
            rate: .fps120,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.num0) == .init(.handled, .focusNextComponent))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Frames_102() async {
        let state = stateModelFactory(
            component: .frames,
            rate: .fps120,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 10)
        
        #expect(state.press(.num2) == .init(.handled, .focusNextComponent))
        #expect(state.value == 102)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_EnforceValid_Frames_01100102() async {
        let state = stateModelFactory(
            component: .frames,
            rate: .fps120,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 11)
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 110)
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 100)
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.num0) == .init(.handled))
        #expect(state.value == 10)
        
        #expect(state.press(.num2) == .init(.handled))
        #expect(state.value == 102)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func continuousWithinComponent_EnforceValid_Frames_120() async {
        let state = stateModelFactory(
            component: .frames,
            rate: .fps120,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.num2) == .init(.handled))
        #expect(state.value == 12)
        
        #expect(state.press(.num0) == .init(.handled, rejection: .invalid))
        #expect(state.value == 12)
    }
    
    // MARK: - Backspace (Delete)
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Hours_Delete_ZeroStartValue_WithValueEntry() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.delete) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.num1) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.num2) == .init(.handled, .focusNextComponent))
        #expect(state.value == 12)
        
        #expect(state.press(.delete) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.num3) == .init(.handled, .focusNextComponent))
        #expect(state.value == 13)
        
        #expect(state.press(.delete) == .init(.handled))
        #expect(state.value == 1)
        
        #expect(state.press(.delete) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.delete) == .init(.handled, .focusPreviousComponent))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Hours_Delete_ZeroStartValue_NoValueEntry() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        #expect(state.press(.delete) == .init(.handled, .focusPreviousComponent))
        #expect(state.value == 0)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Hours_Delete_WithStartValue_NoValueEntry() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 12
        )
        
        #expect(state.press(.delete) == .init(.handled))
        #expect(state.value == 0)
        
        #expect(state.press(.delete) == .init(.handled, .focusPreviousComponent))
        #expect(state.value == 0)
    }
    
    // MARK: - Edge Case: Entering digits on fresh focus with a pre-existing value
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func autoAdvance_EnforceValid_Hours_WithStartValue_WithValueEntry() async {
        let state = stateModelFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 10
        )
        
        #expect(state.isVirgin)
        
        #expect(state.press(.num2) == .init(.handled))
        #expect(state.value == 2)
        #expect(!state.isVirgin)
        
        #expect(state.press(.num3) == .init(.handled, .focusNextComponent))
        #expect(state.value == 23)
    }
    
    // MARK: - Edge Case: Brute force invalid keys
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func bruteForceInvalidKeys() async {
        let validChars: CharacterSet = .decimalDigits
            .union(.newlines)
            .union(.init(".", ",", ":", ";"))
            .union(.init("-", "=", "+"))
            .union(.init([KeyEquivalent.escape.character]))
            .union(.init([KeyEquivalent.return.character, KeyEquivalent.asciiEndOfText.character]))
            .union(.init([KeyEquivalent.upArrow.character, KeyEquivalent.downArrow.character]))
            .union(.init([KeyEquivalent.leftArrow.character, KeyEquivalent.rightArrow.character]))
            .union(.init([KeyEquivalent.delete.character, KeyEquivalent.asciiDEL.character, KeyEquivalent.deleteForward.character]))
        
        let invalidChars = (0x00 ... 0x7F) // ASCII charset
            .map { UnicodeScalar($0) }
            .filter { !validChars.contains($0) }
            .map { Character($0) }
        
        for char in invalidChars {
            let state = stateModelFactory(
                component: .hours,
                inputStyle: .autoAdvance,
                policy: .enforceValid,
                initialValue: 0
            )
            let result = state.press(KeyEquivalent(char))
            #expect(result == .init(.ignored, rejection: .undefinedKey), "char # \(char.unicodeScalars.map(\.value))")
        }
    }
}

// MARK: - Test Utilities

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
fileprivate class MockStateModel {
    private var stateModel: TimecodeField.ComponentView.StateModel
    
    var inputStyle: TimecodeField.InputStyle
    var policy: TimecodeField.ValidationPolicy
    
    init(
        component: Timecode.Component,
        rate: TimecodeFrameRate,
        base: Timecode.SubFramesBase,
        limit: Timecode.UpperLimit,
        inputStyle: TimecodeField.InputStyle,
        policy: TimecodeField.ValidationPolicy,
        initialValue: Int
    ) {
        self.inputStyle = inputStyle
        self.policy = policy
        
        stateModel = .init(
            component: component,
            initialRate: rate,
            initialBase: base,
            initialLimit: limit,
            initialValue: initialValue
        )
    }
    
    /// Convenience caller for `handleKeyPress` for unit tests.
    func press(_ key: KeyEquivalent) -> TimecodeField.KeyResult {
        stateModel.handleKeyPress(key: key, inputStyle: inputStyle, validationPolicy: policy)
    }
    
    // Proxy property accessors
    var component: Timecode.Component { stateModel.component }
    var timecodeProperties: Timecode.Properties { stateModel.timecodeProperties }
    var frameRate: TimecodeFrameRate { stateModel.frameRate }
    var subFramesBase: Timecode.SubFramesBase { stateModel.subFramesBase }
    var upperLimit: Timecode.UpperLimit { stateModel.upperLimit }
    var value: Int { stateModel.value }
    var isVirgin: Bool { stateModel.isVirgin }
}

#endif
