//
//  LoopTest.swift
//  VideoPlayerUITests
//
//  Created by Igor on 03.09.24.
//

import XCTest
@testable import swiftui_loop_videoplayer_example

final class LoopUITest: XCTestCase, Initializable, Navigable, Existing {
     
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
    
    /// Tests the increment of loop counts in a video player over time.
    ///
    /// This test checks the functionality of loop counting by comparing the loop counts at different intervals
    /// to ensure the video is looping as expected. It verifies that the loop count increases over a span of 10 seconds,
    /// indicating that the video player correctly increments the count on each loop.
    ///
    /// The function performs the following steps:
    /// 1. Initializes the XCUIApplication and launches it.
    /// 2. Accesses and taps the video button to start the video.
    /// 3. Waits for the video player to be visible on the screen.
    /// 4. Retrieves the initial loop count and ensures it's greater than zero.
    /// 5. Waits for an additional 10 seconds and retrieves the loop count again.
    /// 6. Verifies that the loop count after 10 seconds is greater than the initial count, confirming proper loop functionality.
    func testLoop() {

        let videoName = Video11.videoPrefix

        tap(button: videoName, wait: 8)
        
        let initialLoopCount = getCurrentLoopCount(app: app)
        XCTAssertGreaterThan(initialLoopCount, 0, "Loop count should be greater than zero after some time playing.")
        
        sleep(10)

        let afterTenSecondsLoopCount = getCurrentLoopCount(app: app)
        XCTAssertGreaterThan(afterTenSecondsLoopCount, initialLoopCount, "Loop count should be greater than initialLoopCount after some time playing.")
        
        back()
    }

    /// Retrieves the current loop count displayed on the screen.
    ///
    /// This helper function fetches the text from the loop counter UI element, extracts the numerical part of
    /// the string, and converts it to an integer.
    ///
    /// - Parameter app: The XCUIApplication instance representing the app.
    /// - Returns: The integer value of the current loop count.
    func getCurrentLoopCount(app: XCUIApplication) -> Int {
        let loopCounterText = check(staticTexts: Video11.loopCounterIdentifier, wait: 5)
        
        return Extractor.extractInt(from: loopCounterText.label) ?? 0
    }
}
