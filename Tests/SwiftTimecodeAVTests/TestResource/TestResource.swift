//
//  TestResource.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import TestingExtensions

// NOTE: DO NOT name any folders "Resources". Xcode will fail to build iOS targets.

// MARK: - Constants

/// Resources files on disk used for unit testing.
extension TestResource {
    static let timecodeTrack_23_976_Start_00_00_00_00 = TestResource.File(
        name: "TimecodeTrack_23_976_Start-00-00-00-00", ext: "mov", subFolder: "Media Files"
    )
    
    static let timecodeTrack_23_976_Start_00_58_40_00 = TestResource.File(
        name: "TimecodeTrack_23_976_Start-00-58-40-00", ext: "mov", subFolder: "Media Files"
    )
    
    static let timecodeTrack_24_Start_00_58_40_00 = TestResource.File(
        name: "TimecodeTrack_24_Start-00-58-40-00", ext: "mov", subFolder: "Media Files"
    )
    
    static let timecodeTrack_29_97d_Start_00_00_00_00 = TestResource.File(
        name: "TimecodeTrack_29_97d_Start_00-00-00-00", ext: "mov", subFolder: "Media Files"
    )
    
    static let videoAndTimecodeTrack_29_97i_Start_00_00_00_00 = TestResource.File(
        name: "VideoAndTimecodeTrack_29_97i_Start-00-00-00-00", ext: "mov", subFolder: "Media Files"
    )
    
    static let videoTrack_25_VFR_1sec = TestResource.File(
        name: "VideoTrack_25_VFR_1sec", ext: "mov", subFolder: "Media Files"
    )
    
    static let videoTrack_25_VFR_2sec = TestResource.File(
        name: "VideoTrack_25_VFR_2sec", ext: "mov", subFolder: "Media Files"
    )
    
    static let videoTrack_29_97_Start_00_00_00_00 = TestResource.File(
        name: "VideoTrack_29_97_Start-00-00-00-00", ext: "mp4", subFolder: "Media Files"
    )
}
