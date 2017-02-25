//
//  Utils.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 2/24/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

class Utils {
    
    static func random(min: Int = 0, max: Int = Int(UInt32.max)) -> Int {
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
    
    static func distanceBetween(a: (x: Int, y: Int), b: (x: Int, y: Int)) -> Double {
        return sqrt(Double((b.y - a.y)^2 + (b.x - a.x)^2))
    }
    
}
