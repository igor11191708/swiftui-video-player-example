//
//  Existing.swift
//  VideoPlayerUITests
//
//  Created by Igor Shelopaev
//

import XCTest

protocol Existing{
    var app : XCUIApplication { get }
}

extension Existing{
    
    @discardableResult
    func check(otherElement : String, wait timeout : TimeInterval = 0 ) -> XCUIElement{
        
        let element = app.otherElements[otherElement]
        XCTAssertTrue(element.waitForExistence(timeout: timeout), "The \(otherElement) should be visible on the screen")
        
        return element
    }
    
    @discardableResult
    func check(staticTexts : String, wait timeout : TimeInterval = 0) -> XCUIElement{
        let text = app.staticTexts[staticTexts]
        XCTAssertTrue(text.waitForExistence(timeout: timeout), "\(staticTexts) should be visible on the screen")
        
        return text
    }
}
