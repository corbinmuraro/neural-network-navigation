//
//  CityGenerator.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 2/24/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

class City {
    
    // Mark: Properties
    private(set) var nodes = Set<Intersection>()
    private(set) var area = (x: 0, y: 0)
    
    // Mark: Privte Properties for Computations
    private var ids = Set<Int>()
    
    
    
    // Mark: Methods
    func generate(area: (x: Int, y: Int), nodeCount: Int) {
        self.area = area
        
    }
    
    // Mark: Convenience Methods
    
    private func random(min: Int = 0, max: Int = Int(UInt32.max)) -> Int {
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
    
}

/*
 This extension deals with the backends for the generation of the city
 */
extension City {
    private func generateConnections(intersection: Intersection, minConnections min: Int, maxConnections max: Int) {
        for node in nodes {
            let connectionCount = random(min: min, max: max)
            for i in 0..<connectionCount {
                
            }
        }
    }
    
    private func generateIntersection() -> Intersection {
        let id = generateIntersectionID()
        let xCoor = random(min: 0, max: area.x)
        let yCoor = random(min: 0, max: area.y)
        
    }
    
    private func generateRoad(intersection: Intersection) -> Road {
        
    }
    
    
    private func generateIntersectionID() -> Int {
        let id = random()
        if ids.contains(id) {
            ids.insert(id)
            return id
        } else {
            return generateIntersectionID()
        }
    }

}

/*
 This extension defines some classes and structs that are used by the class
 */
extension City {
    
    class Intersection: Hashable {
        // Hashable
        var hashValue: Int { return id }
        static func == (lhs: Intersection, rhs: Intersection) -> Bool {
            return lhs.id == rhs.id || (lhs.coor.x == rhs.coor.x && lhs.coor.y == rhs.coor.y)
        }
        
        // Class
        let id: Int
        let coor: (x: Int, y: Int)
        var roads = [Road]()
        
        init(id: Int, coor: (x: Int, y: Int), roads: [Road]) {
            self.id = id
            self.coor = coor
            self.roads = roads
        }
    }
    
    struct Road {
        let start: Intersection
        let end: Intersection
        
        let lanes: Int
        
        var weight: Int {
            return lanes
        }
    }
    
}
