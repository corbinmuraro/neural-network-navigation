//
//  Pathfinder.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 3/9/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

class Pathfinder {
    
    private class Path {
        var total: Int!
        var destination = Vector2.zero
        var previous: Path
    }
    
    func dijkstra(city: City, startPos: Vector2, endPos: Vector2) -> [Vector2]? {
        typealias Intersection = City.Intersection
        
        var frontier = [Path]()
        var finalPaths = [Path]()
        
        for e in
        
        
        
        
        return [Vector2]()
    }
    
    enum PathfinderError: Error {
    case noIntersectionAt(vector: Vector2)
    }
}
