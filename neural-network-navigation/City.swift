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
            var completed = Dictionary<Int, Int>(minimumCapacity: array.count)
            
            for i in 0..<numConnection.count {
                numConnection[i] = Utils.random(min: 1, max: 3)
            }
            
            for i in 0..<array.count {
                
                guard let roadCount = completed[i] else { completed.updateValue(0, forKey: i); break }
                if roadCount < numConnection[i] {
                    completed.updateValue(roadCount + 1, forKey: i)
                } else {
                    continue
                }
                
                let nearest = intersectionsclosest(to: array[i] as! Intersection, among: array)
                for j in 0..<roadCount {
                    let otherIndex = array.index(of: nearest[j])
                    guard let otherRoadCount = completed[otherIndex] else { completed.updateValue(0, forKey: otherIndex); break }
                    if otherRoadCount < numConnection[otherIndex] {
                        completed.updateValue(otherRoadCount + 1, forKey: i)
                    } else {
                        continue
                    }
                    (array[i] as! Intersection).roads.append(Road(start: array[i] as! Intersection, end: nearest[j] , lanes: Utils.random(min: 1, max: 3)))
                }
                
                if let delegate = delegate, i % delegate.intervalSize == 0 {
                    delegate.generateIntersectionPartialComplete(completedNodes: i, totalNodes: array.count)
                }
            }
        }
        
        private func intersectionsclosest(to node: Intersection, among nodes: NSMutableArray) -> [Intersection] {
            return nodes.sorted(by: { ($0 as! Intersection).distance(to: node) < ($1 as! Intersection).distance(to: node)} ) as! [City.Intersection]
        }
        
    }

}

