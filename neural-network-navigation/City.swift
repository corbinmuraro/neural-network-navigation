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
    
    typealias nodeType = NSMutableArray
    
    // Mark: Properties
    fileprivate(set) var nodes = nodeType()
    fileprivate(set) var area: Vector2 = (0,0)
    
    // Mark: Methods
    func generate(cityArea area: Vector2, nodeCount: Int, delegate: CityGeneratorDelegate?) {
        self.area = area
        let generator = Generator()
        generator.delegate = delegate
        nodes = generator.generateIntersections(count: nodeCount, withinArea: area)
        generator.generateRoads(forIntersections: &nodes, connectionCount: (1,3))
        
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
        let a: Intersection
        let b: Intersection
        
        let lanes: Int
        
        var weight: Int {
            return lanes
        }
        
        init(a: Intersection, b: Intersection, lanes: Int) {
            self.a = a
            self.b = b
            self.lanes = lanes
        }
    }
    
    // Mark: Functions For City Generation
    
    class Generator {
        
        var delegate: CityGeneratorDelegate?
        
        func generateIntersections(count: Int, withinArea area: Vector2) -> NSMutableArray {
            let array = NSMutableArray(capacity: count)
            for i in 0..<count {
                let id = i
                let xCoor = Utils.random(min: 0, max: area.x)
                let yCoor = Utils.random(min: 0, max: area.y)
                array.add(Intersection(id: id, coor: (xCoor, yCoor)))
                if let delegate = delegate, i % delegate.intervalSize == 0 {
                    delegate.generateIntersectionPartialComplete(completedNodes: i, totalNodes: count)
                }
            }
            return array
        }
        
        func generateRoads(forIntersections array: inout NSMutableArray, connectionCount: Range) {
            var numConnection = Array<Int>(repeating: 0, count: array.count)
            
            for i in 0..<numConnection.count {
                numConnection[i] = Utils.random(min: 1, max: 3 + 1)
            }
            
            for index in 0..<array.count {
                let node = array[index] as! City.Intersection
                
                let roadCount = node.roads.count
                let roadCountTarget = numConnection[index]
                
                
                if roadCount >= roadCountTarget {
                    continue
                }
                
                //let nearest = intersectionsClosest(to: node, among: array)
                
                let nearest = array
                
                for _ in 0..<roadCountTarget {
                    var foundIndex = false
                    var idx = 0
                    while !foundIndex {
                        idx = Utils.random(min: 0, max: array.count)
                        if idx != index {
                            foundIndex = true
                        }
                    }
                    
                    let otherNode = nearest[idx] as! City.Intersection
                    
                    let otherIndex = array.index(of: otherNode)
                    let otherRoadCount = otherNode.roads.count
                    let otherRoadCountTarget = numConnection[otherIndex]
                    
                    if otherRoadCount >= otherRoadCountTarget {
                        continue
                    }
                    
                    let road = Road(a: node, b: otherNode, lanes: 1)
                    node.roads.append(road)
                    otherNode.roads.append(road)
                    
                }
                
                if let delegate = delegate, index % delegate.intervalSize == 0 {
                    delegate.generateIntersectionPartialComplete(completedNodes: index, totalNodes: array.count)
                }
            }
        }
        
        private func intersectionsClosest(to node: Intersection, among nodes: NSMutableArray) -> [Intersection] {
            var array = nodes.sorted(by: { ($0 as! Intersection).distance(to: node) < ($1 as! Intersection).distance(to: node)} ) as! [City.Intersection]
            array.removeFirst()
            return array
        }
        
    }

}

