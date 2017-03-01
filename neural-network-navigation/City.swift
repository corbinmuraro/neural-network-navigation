//
//  CityGenerator.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 2/24/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

protocol CityGeneratorDelegate {
    var intervalSize: Int { get }
    func generateIntersectionPartialComplete(completedNodes: Int, totalNodes: Int)
    func generateConnectionsPartialComplete(completedNodes: Int, totalNodes: Int)
}

class City {
    
    typealias nodeType = NSMutableSet
    
    // Mark: Properties
    fileprivate(set) var nodes = nodeType()
    fileprivate(set) var area: Vector2 = (0,0)
    
    // Mark: Methods
    func generate(cityArea area: Vector2, nodeCount: Int, delegate: CityGeneratorDelegate?) {
        self.area = area
        let generator = Generator(nodeCount: nodeCount)
        nodes = nodeType(capacity: nodeCount)
        // First generate the nodes
        for i in 0..<nodeCount {
            nodes.add(generator.generateIntersection(withinArea: area))
            if let delegate = delegate, i % delegate.intervalSize == 0 {
                delegate.generateIntersectionPartialComplete(completedNodes: i, totalNodes: nodeCount)
            }
        }
        // Then we look at all the nodes and generate random connection
        var counter = 0
        for node in nodes {
            generator.generateConnections(for: node, nodes: &nodes)
            if let delegate = delegate, counter % delegate.intervalSize == 0 {
                delegate.generateIntersectionPartialComplete(completedNodes: counter, totalNodes: nodeCount)
            }
            counter += 1
        }
        
    }
    
    // Mark: Classses and Structs
    
    class Intersection: Hashable {
        static var zero = Intersection(id: 0, coor: (0,0))
        
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
        
        var connectionRange: Range = (1,3)
        var lanesRange: Range = (1,3)
        var nodeCount: Int
        
        // Mark: Privte Properties for Computations
        fileprivate var ids = Set<Int>()
        
        init(nodeCount: Int) {
            self.nodeCount = nodeCount
        }
        
//        convenience init(connectionRange: Range, lanesRange: Range) {
//            self.connectionRange = connectionRange
//            self.lanesRange = lanesRange
//        }
        
        func generateIntersection(withinArea area: Vector2) -> Intersection {
            let id = generateIntersectionID()
            let xCoor = Utils.random(min: 0, max: area.x)
            let yCoor = Utils.random(min: 0, max: area.y)
            let node = Intersection(id: id, coor: (xCoor, yCoor))
            return node
        }
        
        func generatedConnections(for start: Intersection, nodes: inout nodeType) -> [Road] {
            let endpoints = intersectionsclosest(to: start, among: &nodes)
            
            var connections = [Road]()
            let connectionCount = Utils.random(min: connectionRange.min, max: connectionRange.max)
            for i in 0..<(min(connectionCount, endpoints.count)) {
                let road = generateRoad(start: start, end: endpoints[i])
                connections.append(road)
            }
            return connections
        }
        
        func generateConnections(for start: Intersection, nodes: inout nodeType) {
            start.roads = generatedConnections(for: start, nodes: &nodes)
        }
        
        private func generateRoad(start: Intersection, end: Intersection, lanes: Int = Utils.random(min: 1, max: 3)) -> Road {
            return Road(start: start, end: end, lanes: lanes)
        }
        
        private func intersectionsclosest(to node: Intersection, among nodes: inout nodeType) -> [Intersection] {
            return Array(nodes).sorted(by: {$0.distance(to: node) < $1.distance(to: node)})
        }
        
        private func generateIntersectionID() -> Int {
            let id = Utils.random()
            if !ids.contains(id) {
                ids.insert(id)
                return id
            } else {
                return generateIntersectionID()
            }
        }
        
    }

}

