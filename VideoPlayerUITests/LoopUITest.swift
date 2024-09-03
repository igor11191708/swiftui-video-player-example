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
    
    func testLoop() {
        let app = XCUIApplication()
        app.launch()

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

    func getCurrentLoopCount(app: XCUIApplication) -> Int {
        let loopCounterText = app.staticTexts["Video_LoopCounter"]
        XCTAssertTrue(loopCounterText.waitForExistence(timeout: 10), "Loop counter text should be visible on the screen")
     
        
        let loopCountValue = extractLoopCount(from: loopCounterText.label)
        return Int(loopCountValue)
    }
    
    func extractLoopCount(from text: String) -> Int {
        // Extracting the number from text "Loop count X"
        let loopCountString = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return Int(loopCountString) ?? 0
    }
}
