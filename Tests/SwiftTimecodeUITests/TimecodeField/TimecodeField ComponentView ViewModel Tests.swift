//
//  TimecodeField ComponentView ViewModel Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
@testable import SwiftTimecodeUI
import Testing

@Suite struct TimecodeField_ComponentView_ViewModel_Tests {
    // MARK: - Test Facilities
    
    private let testFrameRate: TimecodeFrameRate = .fps24
    private let testSubFramesBase: Timecode.SubFramesBase = .max100SubFrames
    
    private func viewModelFactory(
        component: Timecode.Component,
        rate: TimecodeFrameRate? = nil,
        base: Timecode.SubFramesBase? = nil,
        limit: Timecode.UpperLimit
    ) -> MockViewModel {
        let properties = Timecode.Properties(
            rate: rate ?? testFrameRate,
            base: base ?? testSubFramesBase,
            limit: limit
        )
        return MockViewModel(
            component: component,
            initialTimecodeProperties: properties
        )
    }
    
    // MARK: - Tests
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func baselineState() async {
        let model = viewModelFactory(component: .days, limit: .max24Hours)
        
        #expect(model.component == .days)
        #expect(model.frameRate == testFrameRate)
        #expect(model.subFramesBase == testSubFramesBase)
        #expect(model.upperLimit == .max24Hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func baselineStateB() async {
        let model = viewModelFactory(component: .hours, rate: .fps30, base: .max80SubFrames, limit: .max100Days)
        
        #expect(model.component == .hours)
        #expect(model.frameRate == .fps30)
        #expect(model.subFramesBase == .max80SubFrames)
        #expect(model.upperLimit == .max100Days)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func invisibleComponents_Max24Hours() async {
        let model = viewModelFactory(component: .days, limit: .max24Hours)
        
        #expect(model.invisibleComponents(timecodeFormat: []) == [.days, .subFrames])
        
        #expect(model.invisibleComponents(timecodeFormat: [.showSubFrames]) == [.days])
        
        #expect(model.invisibleComponents(timecodeFormat: [.alwaysShowDays, .showSubFrames]) == [])
        
        #expect(model.invisibleComponents(timecodeFormat: [.alwaysShowDays]) == [.subFrames])
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func invisibleComponents_Max100Hours() async {
        let model = viewModelFactory(component: .days, limit: .max100Days)
        
        #expect(model.invisibleComponents(timecodeFormat: []) == [.subFrames])
        
        #expect(model.invisibleComponents(timecodeFormat: [.showSubFrames]) == [])
        
        #expect(model.invisibleComponents(timecodeFormat: [.alwaysShowDays, .showSubFrames]) == [])
        
        #expect(model.invisibleComponents(timecodeFormat: [.alwaysShowDays]) == [.subFrames])
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func firstVisibleComponent_Max24Hours() async {
        let model = viewModelFactory(component: .days, limit: .max24Hours)
        
        #expect(model.firstVisibleComponent(timecodeFormat: []) == .hours)
        
        #expect(model.firstVisibleComponent(timecodeFormat: [.showSubFrames]) == .hours)
        
        #expect(model.firstVisibleComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames]) == .days)
        
        #expect(model.firstVisibleComponent(timecodeFormat: [.alwaysShowDays]) == .days)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func firstVisibleComponent_Max100Hours() async {
        let model = viewModelFactory(component: .days, limit: .max100Days)
        
        #expect(model.firstVisibleComponent(timecodeFormat: []) == .days)
        
        #expect(model.firstVisibleComponent(timecodeFormat: [.showSubFrames]) == .days)
        
        #expect(model.firstVisibleComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames]) == .days)
        
        #expect(model.firstVisibleComponent(timecodeFormat: [.alwaysShowDays]) == .days)
    }
    
    // MARK: - .previousComponent (24 Hours)
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func days_PreviousComponent_Max24Hours() async {
        let model = viewModelFactory(component: .days, limit: .max24Hours)
        
        #expect(model.previousComponent(timecodeFormat: [], wrap: .wrap) == .frames)
        #expect(model.previousComponent(timecodeFormat: [.showSubFrames], wrap: .wrap) == .subFrames)
        #expect(model.previousComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap) == .subFrames)
        #expect(model.previousComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap) == .frames)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func hours_PreviousComponent_Max24Hours() async {
        let model = viewModelFactory(component: .hours, limit: .max24Hours)
        
        #expect(model.previousComponent(timecodeFormat: [], wrap: .wrap) == .frames)
        #expect(model.previousComponent(timecodeFormat: [.showSubFrames], wrap: .wrap) == .subFrames)
        #expect(model.previousComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap) == .days)
        #expect(model.previousComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap) == .days)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func subframes_PreviousComponent_Max24Hours() async {
        let model = viewModelFactory(component: .subFrames, limit: .max24Hours)
        
        #expect(model.previousComponent(timecodeFormat: [], wrap: .wrap) == .frames)
        #expect(model.previousComponent(timecodeFormat: [.showSubFrames], wrap: .wrap) == .frames)
        #expect(model.previousComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap) == .frames)
        #expect(model.previousComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap) == .frames)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func frames_PreviousComponent_Max24Hours() async {
        let model = viewModelFactory(component: .frames, limit: .max24Hours)
        
        #expect(model.previousComponent(timecodeFormat: [], wrap: .wrap) == .seconds)
        #expect(model.previousComponent(timecodeFormat: [.showSubFrames], wrap: .wrap) == .seconds)
        #expect(model.previousComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap) == .seconds)
        #expect(model.previousComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap) == .seconds)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    // MARK: - .previousComponent (100 Days)
    
    func days_PreviousComponent_Max100Days() async {
        let model = viewModelFactory(component: .days, limit: .max100Days)
        
        #expect(model.previousComponent(timecodeFormat: [], wrap: .wrap) == .frames)
        #expect(model.previousComponent(timecodeFormat: [.showSubFrames], wrap: .wrap) == .subFrames)
        #expect(model.previousComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap) == .subFrames)
        #expect(model.previousComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap) == .frames)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func hours_PreviousComponent_Max100Days() async {
        let model = viewModelFactory(component: .hours, limit: .max100Days)
        
        #expect(model.previousComponent(timecodeFormat: [], wrap: .wrap) == .days)
        #expect(model.previousComponent(timecodeFormat: [.showSubFrames], wrap: .wrap) == .days)
        #expect(model.previousComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap) == .days)
        #expect(model.previousComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap) == .days)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func subframes_PreviousComponent_Max100Days() async {
        let model = viewModelFactory(component: .subFrames, limit: .max100Days)
        
        #expect(model.previousComponent(timecodeFormat: [], wrap: .wrap) == .frames)
        #expect(model.previousComponent(timecodeFormat: [.showSubFrames], wrap: .wrap) == .frames)
        #expect(model.previousComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap) == .frames)
        #expect(model.previousComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap) == .frames)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func frames_PreviousComponent_Max100Days() async {
        let model = viewModelFactory(component: .frames, limit: .max100Days)
        
        #expect(model.previousComponent(timecodeFormat: [], wrap: .wrap) == .seconds)
        #expect(model.previousComponent(timecodeFormat: [.showSubFrames], wrap: .wrap) == .seconds)
        #expect(model.previousComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap) == .seconds)
        #expect(model.previousComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap) == .seconds)
    }
    
    // MARK: - .nextComponent (24 Hours)
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func days_NextComponent_Max24Hours() async {
        let model = viewModelFactory(component: .days, limit: .max24Hours)
        
        #expect(model.nextComponent(timecodeFormat: [], wrap: .wrap) == .hours)
        #expect(model.nextComponent(timecodeFormat: [.showSubFrames], wrap: .wrap) == .hours)
        #expect(model.nextComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap) == .hours)
        #expect(model.nextComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap) == .hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func hours_NextComponent_Max24Hours() async {
        let model = viewModelFactory(component: .hours, limit: .max24Hours)
        
        #expect(model.nextComponent(timecodeFormat: [], wrap: .wrap) == .minutes)
        #expect(model.nextComponent(timecodeFormat: [.showSubFrames], wrap: .wrap) == .minutes)
        #expect(model.nextComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap) == .minutes)
        #expect(model.nextComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap) == .minutes)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func frames_NextComponent_Max24Hours() async {
        let model = viewModelFactory(component: .frames, limit: .max24Hours)
        
        #expect(model.nextComponent(timecodeFormat: [], wrap: .wrap) == .hours)
        #expect(model.nextComponent(timecodeFormat: [.showSubFrames], wrap: .wrap) == .subFrames)
        #expect(model.nextComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap) == .subFrames)
        #expect(model.nextComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap) == .days)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func subframes_NextComponent_Max24Hours() async {
        let model = viewModelFactory(component: .subFrames, limit: .max24Hours)
        
        #expect(model.nextComponent(timecodeFormat: [], wrap: .wrap) == .hours)
        #expect(model.nextComponent(timecodeFormat: [.showSubFrames], wrap: .wrap) == .hours)
        #expect(model.nextComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap) == .days)
        #expect(model.nextComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap) == .days)
    }
    
    // MARK: - .nextComponent (100 Days)
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func days_NextComponent_Max100Days() async {
        let model = viewModelFactory(component: .days, limit: .max100Days)
        
        #expect(model.nextComponent(timecodeFormat: [], wrap: .wrap) == .hours)
        #expect(model.nextComponent(timecodeFormat: [.showSubFrames], wrap: .wrap) == .hours)
        #expect(model.nextComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap) == .hours)
        #expect(model.nextComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap) == .hours)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func hours_NextComponent_Max100Days() async {
        let model = viewModelFactory(component: .hours, limit: .max100Days)
        
        #expect(model.nextComponent(timecodeFormat: [], wrap: .wrap) == .minutes)
        #expect(model.nextComponent(timecodeFormat: [.showSubFrames], wrap: .wrap) == .minutes)
        #expect(model.nextComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap) == .minutes)
        #expect(model.nextComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap) == .minutes)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func frames_NextComponent_Max100Days() async {
        let model = viewModelFactory(component: .frames, limit: .max100Days)
        
        #expect(model.nextComponent(timecodeFormat: [], wrap: .wrap) == .days)
        #expect(model.nextComponent(timecodeFormat: [.showSubFrames], wrap: .wrap) == .subFrames)
        #expect(model.nextComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap) == .subFrames)
        #expect(model.nextComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap) == .days)
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func subframes_NextComponent_Max100Days() async {
        let model = viewModelFactory(component: .subFrames, limit: .max100Days)
        
        #expect(model.nextComponent(timecodeFormat: [], wrap: .wrap) == .days)
        #expect(model.nextComponent(timecodeFormat: [.showSubFrames], wrap: .wrap) == .days)
        #expect(model.nextComponent(timecodeFormat: [.alwaysShowDays, .showSubFrames], wrap: .wrap) == .days)
        #expect(model.nextComponent(timecodeFormat: [.alwaysShowDays], wrap: .wrap) == .days)
    }
    
    // MARK: - ViewModel.isDaysVisible()
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func isDaysVisible_Max24Hours() async {
        typealias VM = TimecodeField.ComponentView.ViewModel
        
        #expect(!VM.isDaysVisible(format: [], limit: .max24Hours))
        #expect(!VM.isDaysVisible(format: [.showSubFrames], limit: .max24Hours))
        #expect(VM.isDaysVisible(format: [.alwaysShowDays, .showSubFrames], limit: .max24Hours))
        #expect(VM.isDaysVisible(format: [.alwaysShowDays], limit: .max24Hours))
    }
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func isDaysVisible_Max100Days() async {
        typealias VM = TimecodeField.ComponentView.ViewModel
        
        #expect(VM.isDaysVisible(format: [], limit: .max100Days))
        #expect(VM.isDaysVisible(format: [.showSubFrames], limit: .max100Days))
        #expect(VM.isDaysVisible(format: [.alwaysShowDays, .showSubFrames], limit: .max100Days))
        #expect(VM.isDaysVisible(format: [.alwaysShowDays], limit: .max100Days))
    }
    
    // MARK: - ViewModel.isSubFramesVisible()
    
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Test
    func isSubFramesVisible() async {
        typealias VM = TimecodeField.ComponentView.ViewModel
        
        #expect(!VM.isSubFramesVisible(format: []))
        #expect(VM.isSubFramesVisible(format: [.showSubFrames]))
        #expect(VM.isSubFramesVisible(format: [.alwaysShowDays, .showSubFrames]))
        #expect(!VM.isSubFramesVisible(format: [.alwaysShowDays]))
    }
}

// MARK: - Test Utilities

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
fileprivate class MockViewModel: TimecodeField.ComponentView.ViewModel {
    
}

#endif
