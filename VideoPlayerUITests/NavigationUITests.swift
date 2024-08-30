//
//  ContentViewUITests.swift
//  VideoPlayerUITests
//
//  Created by Igor Shelopaev  on 29.08.24.
// print(XCUIApplication().debugDescription)

import XCTest
import SwiftUI
@testable import swiftui_loop_videoplayer_example

final class NavigationUITests: XCTestCase {

    /// Tests the navigation from the main view to various video views and back.
    ///
    /// This test verifies that each video button in the `VideoPlayerModel.data` array correctly navigates to
    /// its respective video view, which should display an `ExtVideoPlayer`. After verifying the presence of
    /// the `ExtVideoPlayer`, the test taps the back button to return to the main view and ensures that the
    /// main view (ContentView) is visible again.
    ///
    /// The function performs the following steps:
    /// 1. Initializes the app and launches it.
    /// 2. Iterates through each video model in the `VideoPlayerModel.data` array.
    /// 3. Locates and taps the button for each video model.
    /// 4. Confirms that the video view, including the `ExtVideoPlayer`, is displayed.
    /// 5. Taps the back button to return to the main view.
    /// 6. Verifies that the main view (ContentView) is visible again.
    func testNavigationToVideoView() {
        
        let data = VideoPlayerModel.data
        
        let app = XCUIApplication()
        app.launch()

        for video in data {
            
            let videoButton = app.buttons.matching(identifier: video.name).firstMatch
            XCTAssertTrue(videoButton.exists, "The \(video.name) button should exist")
            
            videoButton.tap()
            
            let videoPlayer = app.otherElements["\(video.name)_ExtVideoPlayer"]
            XCTAssertTrue(videoPlayer.waitForExistence(timeout: 5), "The ExtVideoPlayer included in \(video.name) should be visible on the screen")
            
            let backButton = app.navigationBars.buttons.element(boundBy: 0)
            XCTAssertTrue(backButton.exists, "The Back button should exist")
            backButton.tap()
            
            let contentView = app.otherElements["ContentView"]
            XCTAssertTrue(contentView.waitForExistence(timeout: 5), "ContentView should be visible again")
        }
    }
}
