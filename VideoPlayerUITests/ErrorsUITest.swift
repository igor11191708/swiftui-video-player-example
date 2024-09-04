//
//  ErrorsUITest.swift
//  VideoPlayerUITests
//
//  Created by Igor  on 04.09.24.
//

import XCTest
import swiftui_loop_videoplayer

final class ErrorsUITest: XCTestCase, Initializable, Navigable {

    override class func setUp() {
        super.setUp()
        AppManager.shared.launchApplicationIfNeeded()
    }
    
    func testErrorResourceNotFound(){

        let videoName = Video3.videoPrefix

        tap(button: videoName, wait: 8)
        
        let error = getCurrentErrorText(app: app)
        let description = VPErrors.sourceNotFound(Video3.sourceName).description
        
        XCTAssertEqual(description, error)
        
        back()
    }
    
    func getCurrentErrorText(app: XCUIApplication) -> String {
        let errorText = app.staticTexts["\(Video3.errorWidgetIdentifier)"]
        XCTAssertTrue(errorText.waitForExistence(timeout: 5), "Error text should be visible on the screen")
        
        return errorText.label
    }
}
