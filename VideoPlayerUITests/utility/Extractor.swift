//
//  Extractor.swift
//  VideoPlayerUITests
//
//  Created by Igor Shelopaev
//

import Foundation

struct Extractor{
    
   /// Extracts an integer from a string by removing non-digit characters.
   ///
   /// - Parameter text: The string from which to extract digits.
   /// - Returns: An optional `Int` derived from the digits in the string. Returns `nil` if no digits are found or if the numeric value is too large for the `Int` type.
   static func extractInt(from text: String) -> Int? {
        let decimalDigits = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return Int(decimalDigits)
    }
}
