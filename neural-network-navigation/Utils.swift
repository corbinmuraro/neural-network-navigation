//
//  Utils.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 2/24/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

// Defining commonly used Type Alias for the program
typealias Vector2 = (x: Int, y: Int)
typealias Range = (min: Int, max: Int)

/* Class Description: Utils
 Utils is the class containing convenience methods and useful properties for the entire program.
 */

class Utils {
    
    static func random(min: Int = 0, max: Int = Int(UInt32.max)) -> Int {
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
    
    static func distanceBetween(a: (x: Int, y: Int), b: (x: Int, y: Int)) -> Double {
        return sqrt(Double((b.y - a.y)^2 + (b.x - a.x)^2))
    }
}

extension NumberFormatter {
    func number(fromUngrouped string: String) -> NSNumber? {
        if let separator = Locale.current.groupingSeparator {
            return number(from: string.replacingOccurrences(of: separator, with: ""))
        } else {
            return number(from: string)
        }
    }
}

