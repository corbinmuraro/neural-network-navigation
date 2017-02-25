//
//  CityGenerator.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 2/24/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

class City {
    
    typealias Vector2 = (x: Int, y: Int)
    
    // Mark: Properties
    fileprivate(set) var nodes = Set<Intersection>()
    fileprivate(set) var area: Vector2 = (0,0)
    
    // Mark: Init and Static Vars
    
    static var defaultConfig: City {
        let city = City()
        city.generate(cityArea: (10,10), nodeCount: 20)
        return city
    }
    
    // Mark: Methods
    func generate(cityArea area: Vector2, nodeCount: Int) {
        self.area = area
        let generator = Generator()
        for _ in 0..<nodeCount {
            nodes.insert(generator.generateIntersection(withinArea: area, nodes: &nodes))
        }
        
    }
    
    // Mark: Convenience Methods
    
    
    
    // Mark: Classses and Structs
    
    class Intersection: Hashable {
        // Hashable
        var hashValue: Int { return id }
        static func == (lhs: Intersection, rhs: Intersection) -> Bool {
            return lhs.id == rhs.id || (lhs.coor.x == rhs.coor.x && lhs.coor.y == rhs.coor.y)
        }
        
        // Class
        let id: Int
        let coor: Vector2
        var roads = [Road]()
        
        init(id: Int, coor: Vector2) {
            self.id = id
            self.coor = coor
        }
        
        // Convenience
        func distance(to destination: Intersection) -> Double {
            return Utils.distanceBetween(a: self.coor, b: destination.coor)
        }
    }
    
    class Road {
        let start: Intersection
        let end: Intersection
        
        let lanes: Int
        
        var weight: Int {
            return lanes
        }
        
        init(start: Intersection, end: Intersection, lanes: Int) {
            self.start = start
            self.end = end
            self.lanes = lanes
        }
    }
    
    // Mark: Functions For City Generation
    
    class Generator {
        
        typealias Range = (min: Int, max: Int)
        
        var connectionRange: Range = (1,3)
        var lanesRange: Range = (1,3)
        
        // Mark: Privte Properties for Computations
        fileprivate var ids = Set<Int>()
        
//        convenience init(connectionRange: Range, lanesRange: Range) {
//            self.connectionRange = connectionRange
//            self.lanesRange = lanesRange
//        }
        
        func generateIntersection(withinArea area: Vector2, nodes: inout Set<Intersection>) -> Intersection {
            let id = generateIntersectionID()
            let xCoor = Utils.random(min: 0, max: area.x)
            let yCoor = Utils.random(min: 0, max: area.y)
            let node = Intersection(id: id, coor: (xCoor, yCoor))
            node.roads = generateConnections(for: node, nodes: &nodes)
            return node
        }
        
        private func generateConnections(for start: Intersection, nodes: inout Set<Intersection>) -> [Road] {
            let endpoints = intersectionsclosest(to: start, among: &nodes)
            
            var connections = [Road]()
            let connectionCount = Utils.random(min: connectionRange.min, max: connectionRange.max)
            for i in 0..<connectionCount {
                let road = generateRoad(start: start, end: endpoints[i])
                connections.append(road)
            }
            return connections
        }
        
        private func generateRoad(start: Intersection, end: Intersection, lanes: Int = Utils.random(min: 1, max: 3)) -> Road {
            return Road(start: start, end: end, lanes: lanes)
        }
        
        private func intersectionsclosest(to node: Intersection, among nodes: inout Set<Intersection>) -> [Intersection] {
            return Array(nodes).sorted(by: {$0.distance(to: node) < $1.distance(to: node)})
        }
        
        private func generateIntersectionID() -> Int {
            let id = Utils.random()
            if ids.contains(id) {
                ids.insert(id)
                return id
            } else {
                return generateIntersectionID()
            }
        }
        
    }

}

