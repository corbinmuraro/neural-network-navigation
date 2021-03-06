//
//  Utils.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 2/24/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

// Defining commonly used Type Alias for the program
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

struct Vector2: Equatable, CustomStringConvertible {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x; self.y = y
    }
    
    var description: String {
        return "(\(x),\(y))"
    }
    
    static let zero = Vector2(x: 0, y: 0)
    static let up = Vector2(x: 0, y: 1)
    static let down = Vector2(x: 0, y: -1)
    static let left = Vector2(x: -1, y: 0)
    static let right = Vector2(x: 1, y: 0)
    
    static func +(lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func -(lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func +=(lhs: inout Vector2, rhs: Vector2) {
        lhs = lhs + rhs
    }
    static func -=(lhs: inout Vector2, rhs: Vector2) {
        lhs = lhs - rhs
    }
    
    static func ==(lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    static func !=(lhs: Vector2, rhs: Vector2) -> Bool {
        return !(lhs == rhs)
    }
    
    static func random(max: Vector2) -> Vector2 {
        let x = Utils.random(min: 0, max: max.x)
        let y = Utils.random(min: 0, max: max.y)
        return Vector2(x: x, y: y)
    }
    
    func isOutOf(bounds: Vector2) -> Bool {
        return (self.x >= bounds.x || self.x < 0) || (self.y >= bounds.y || self.y < 0)
    }
    
    func distance(to dest: Vector2) -> Int {
        return abs(dest.x - self.x) + abs(dest.y - self.y)
    }
    
    func angle(to dest: Vector2) -> Float {
        let rad = atan2f(Float(dest.y - self.y), Float(dest.x - self.x))
        return rad * Float(180 / M_PI)
    }
    
    func normalized() -> Vector2 {
        switch self.angle(to: Vector2.zero) {
        case -45...45:
            return Vector2.right
        case 45...135:
            return Vector2.up
        case 135...180, -180 ... -135:
            return Vector2.left
        case -135 ... -45:
            return Vector2.down
        default:
            return Vector2.zero
        }
    }
}











