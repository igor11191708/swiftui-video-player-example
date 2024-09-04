//
//  Navigable.swift
//  VideoPlayerUITests
//
//  Created by Igor  on 04.09.24.
//

import XCTest

protocol Navigable{
    var app : XCUIApplication { get }
}

extension Navigable{
    
    func back(){
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.exists, "The Back button should exist")
        backButton.tap()
    }
    
    func tap(button identifier: String, wait timeout : TimeInterval = 0 ){
        let videoButton = app.buttons.matching(identifier: identifier).firstMatch
        XCTAssertTrue(videoButton.waitForExistence(timeout: timeout), "The \(identifier) button should exist")
        
        videoButton.tap()
    }
}
