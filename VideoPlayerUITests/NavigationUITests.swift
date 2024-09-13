//
//  ContentViewUITests.swift
//  VideoPlayerUITests
//
//  Created by Igor Shelopaev on 29.08.24.
// print(XCUIApplication().debugDescription)

import XCTest
import SwiftUI
@testable import swiftui_loop_videoplayer_example

final class NavigationUITests: XCTestCase, Initializable, Navigable, Existing {

    /// Prepares the test class for execution by ensuring the application is launched if not already running and sets failure handling.
    ///
    /// Throws an error if the setup process fails, potentially causing all subsequent tests to be skipped.
    override func setUpWithError() throws {

        continueAfterFailure = false
        
        AppManager.shared.launchApplicationIfNeeded()
    }
    
    override class func tearDown() {
        AppManager.shared.terminateApplication()
    }
    
    /// Tests the navigation from the main view to various video views and back.
    ///
    /// This test verifies that each video button in the `VideoPlayerModel.data` array correctly navigates to
    /// its respective video view, which should display an `ExtVideoPlayer`. After verifying the presence of
    /// the `ExtVideoPlayer`, the test taps the back button to return to the main view and ensures that the
    /// main view (ContentView) is visible again.
    ///
    /// The function performs the following steps:
    /// 1. Iterates through each video model in the `VideoPlayerModel.data` array.
    /// 2. Locates and taps the button for each video model.
    /// 3. Confirms that the video view, including the `ExtVideoPlayer`, is displayed.
    /// 4. Taps the back button to return to the main view.
    /// 5. Verifies that the main view (ContentView) is visible again.
    func testNavigationToVideoView() {
        
        let data = VideoPlayerModel.data

        for video in data {
            tap(button: video.name)
            check(otherElement: "\(video.name)_ExtVideoPlayer", wait: 5)
            back()
            check(otherElement: "ContentView", wait: 5)
        }
    }
}
