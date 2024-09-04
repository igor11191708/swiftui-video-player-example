//
//  Initializable.swift
//  VideoPlayerUITests
//
//  Created by Igor  on 04.09.24.
//

import XCTest

protocol Initializable{
    
}

extension Initializable{
    
    var app : XCUIApplication{
        AppManager.shared.app
    }
    
}
