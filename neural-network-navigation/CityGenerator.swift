//
//  CityGenerator.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 2/24/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

class City {
    
    private var nodes = [Intersection]()
    
    
    func generate(size: Int) {
        
    }
    
    private func generateRandomConnections(minConnections min: Int, maxConnections max: Int) {
        for node in nodes {
            let connectionCount = Int(arc4random_uniform(UInt32(max - min))) + min
            
        }
    }
    
    
}

extension City {
    
    struct Intersection {
        let coor: (x: Int, y: Int)
        let roads: [Road]
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
