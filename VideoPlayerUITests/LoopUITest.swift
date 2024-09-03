//
//  LoopTest.swift
//  VideoPlayerUITests
//
//  Created by Igor  on 03.09.24.
//

import XCTest
@testable import swiftui_loop_videoplayer_example

final class LoopUITest: XCTestCase {
    
    let videoName : String = "Video"
    
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
        let app = XCUIApplication()
        app.launch()  // Launches the application

        let videoButton = app.buttons.matching(identifier: videoName).firstMatch
        XCTAssertTrue(videoButton.exists, "The \(videoName) button should exist")
        
        videoButton.tap()

        let videoPlayer = app.otherElements["Video_ExtVideoPlayer"]
        XCTAssertTrue(videoPlayer.waitForExistence(timeout: 8), "The ExtVideoPlayer should be visible on the screen")
        
        let initialLoopCount = getCurrentLoopCount(app: app)
        XCTAssertGreaterThan(initialLoopCount, 0, "Loop count should be greater than zero after some time playing.")
        
        sleep(10)

        let afterTenSecondsLoopCount = getCurrentLoopCount(app: app)
        XCTAssertGreaterThan(afterTenSecondsLoopCount, initialLoopCount, "Loop count should be greater than initialLoopCount after some time playing.")
    }

    /// Retrieves the current loop count displayed on the screen.
    ///
    /// This helper function fetches the text from the loop counter UI element, extracts the numerical part of
    /// the string, and converts it to an integer.
    ///
    /// - Parameter app: The XCUIApplication instance representing the app.
    /// - Returns: The integer value of the current loop count.
    func getCurrentLoopCount(app: XCUIApplication) -> Int {
        let loopCounterText = app.staticTexts["Video_LoopCounter"]
        XCTAssertTrue(loopCounterText.waitForExistence(timeout: 10), "Loop counter text should be visible on the screen")
        
        return extractLoopCount(from: loopCounterText.label)
    }

    /// Extracts the loop count number from a text string.
    ///
    /// This function parses a string assumed to contain the format "Loop count X" and extracts the number
    /// representing the loop count. It is used to interpret UI text as a usable integer.
    ///
    /// - Parameter text: The string containing the loop count text.
    /// - Returns: The loop count as an integer.
    func extractLoopCount(from text: String) -> Int {
        let loopCountString = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return Int(loopCountString) ?? 0
    }
}
