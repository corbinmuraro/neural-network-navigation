//
//  CityGenerator.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 2/24/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

protocol CityGeneratorDelegate {
    func intervalSize() -> Int
    func generateIntersectionPartialComplete(completedNodes: Int, totalNodes: Int)
    func generateConnectionsPartialComplete(completedNodes: Int, totalNodes: Int)
}

class City {
    
    private(set) var nodes = NSMutableArray()
    let xLim: Int
    let yLim: Int
    var size: Vector2 { return Vector2(x: xLim, y: yLim) }
        
    init(size: Vector2) {
        xLim = size.x; yLim = size.y
        let capacity = oneDimFormula(coor: Vector2(x: xLim, y: yLim - 1))
        nodes = NSMutableArray(capacity: capacity)
        for _ in 0..<capacity {
            nodes.add(Intersection.zero)
        }
    }
    
    private func oneDimFormula(coor: Vector2) -> Int { return coor.y * xLim + coor.x }
    private func twoDimFormula(idx: Int) -> Vector2 { return Vector2(x:idx % (xLim), y: idx / (xLim)) }
    
    func intersection(at coor: Vector2) -> Intersection? { return  nodes.object(at: oneDimFormula(coor: coor)) as? Intersection }
    func set(intersection: Intersection, at coor: (x: Int, y: Int)) { nodes.replaceObject(at: oneDimFormula(coor: Vector2(x: coor.x, y: coor.y)), with: intersection) }
    
    func generate(openRoadBias: Double, delegate: CityGeneratorDelegate?) {
        generateIntersections(delegate: delegate)
        generateConnections(openRoadBias: openRoadBias, delegate: delegate)
    }
    
    func generateConnections(openRoadBias: Double, delegate: CityGeneratorDelegate?) {
        for idx in 0..<nodes.count {
            guard let node = nodes.object(at: idx) as? Intersection else { continue }
            let coor = node.coor
            // up
            if coor.y >= yLim - 1 { node.connections.up = false }
            else {
                let isOpenRoad = Random.numberFromZeroToOne() < openRoadBias
                node.connections.up = isOpenRoad
                node.connections.upWeight = Float(Utils.random(min: 1, max: 5))
                guard let upNode = nodes.object(at: oneDimFormula(coor: coor + Vector2.up)) as? Intersection else { break }
                upNode.connections.down = isOpenRoad
                upNode.connections.downWeight = Float(Utils.random(min: 1, max: 5))
            }
            // down
            if coor.y <= 0 { node.connections.down = false }
            else {
                let isOpenRoad = Random.numberFromZeroToOne() < openRoadBias
                node.connections.down = isOpenRoad
                node.connections.downWeight = Float(Utils.random(min: 1, max: 5))
                guard let downNode = nodes.object(at: oneDimFormula(coor: coor + Vector2.down)) as? Intersection else { break }
                downNode.connections.up = isOpenRoad
                downNode.connections.upWeight = Float(Utils.random(min: 1, max: 5))
            }
            // left
            if coor.x <= 0 { node.connections.left = false }
            else {
                let isOpenRoad = Random.numberFromZeroToOne() < openRoadBias
                node.connections.left = isOpenRoad
                node.connections.leftWeight = Float(Utils.random(min: 1, max: 5))
                guard let leftNode = nodes.object(at: oneDimFormula(coor: coor + Vector2.left)) as? Intersection else { break }
                leftNode.connections.right = isOpenRoad
                leftNode.connections.rightWeight = Float(Utils.random(min: 1, max: 5))
            }
            // right
            if coor.x >= xLim - 1 { node.connections.right = false }
            else {
                let isOpenRoad = Random.numberFromZeroToOne() < openRoadBias
                node.connections.right = isOpenRoad
                node.connections.rightWeight = Float(Utils.random(min: 1, max: 5))
                guard let rightNode = nodes.object(at: oneDimFormula(coor: coor + Vector2.right)) as? Intersection else { break }
                rightNode.connections.left = isOpenRoad
                rightNode.connections.leftWeight = Float(Utils.random(min: 1, max: 5))
            }
            
            // Delegate
            if let delegate = delegate, idx % delegate.intervalSize() == 0 {
                delegate.generateConnectionsPartialComplete(completedNodes: idx, totalNodes: nodes.count)
            }
        }
    }
    
    func generateIntersections(delegate: CityGeneratorDelegate?) {
        for i in 0..<oneDimFormula(coor: Vector2(x: xLim, y: yLim - 1)) {
            nodes.replaceObject(at: i, with: Intersection(id: i, coor: twoDimFormula(idx: i)))
            
            // Delegate
            if let delegate = delegate, i % delegate.intervalSize() == 0 {
                delegate.generateConnectionsPartialComplete(completedNodes: i, totalNodes: nodes.count)
            }
        }
    }
    
    class Intersection: Hashable {
        static var zero = Intersection(id: -1, coor: Vector2.zero)
        
        // Hashable
        var hashValue: Int { return id }
        static func == (lhs: Intersection, rhs: Intersection) -> Bool {
            return lhs.id == rhs.id || (lhs.coor.x == rhs.coor.x && lhs.coor.y == rhs.coor.y)
        }
        let id: Int
        let coor: Vector2
        var connections: Connections
        
        init(id: Int, coor: Vector2) {
            self.id = id
            self.coor = coor
            connections = Connections()
        }
    }
    
    struct Connections {
        var up, down, left, right: Bool?
        var upWeight = Float(1), downWeight = Float(1), leftWeight = Float(1), rightWeight = Float(1)
    }
    
}

//class City {
//    
//    typealias nodeType = NSMutableArray
//    
//    // Mark: Properties
//    fileprivate(set) var nodes = nodeType()
//    fileprivate(set) var area: Vector2 = (0,0)
//    
//    // Mark: Methods
//    func generate(cityArea area: Vector2, nodeCount: Int, delegate: CityGeneratorDelegate?) {
//        self.area = area
//        let generator = Generator()
//        generator.delegate = delegate
//        nodes = generator.generateIntersections(count: nodeCount, withinArea: area)
//        generator.generateRoads(forIntersections: &nodes, connectionCount: (1,3))
//        
//    }
//    
//    // Mark: Classses and Structs
//    
//    class Intersection: Hashable {
//        static var zero = Intersection(id: 0, coor: (0,0))
//        
//        // Hashable
//        var hashValue: Int { return id }
//        static func == (lhs: Intersection, rhs: Intersection) -> Bool {
//            return lhs.id == rhs.id || (lhs.coor.x == rhs.coor.x && lhs.coor.y == rhs.coor.y)
//        }
//        
//        // Class
//        let id: Int
//        let coor: Vector2
//        var roads = [Road]()
//        
//        init(id: Int, coor: Vector2) {
//            self.id = id
//            self.coor = coor
//        }
//        
//        // Convenience
//        func distance(to destination: Intersection) -> Double {
//            return Utils.distanceBetween(a: self.coor, b: destination.coor)
//        }
//    }
//    
//    class Road {
//        let a: Intersection
//        let b: Intersection
//        
//        let lanes: Int
//        
//        var weight: Int {
//            return lanes
//        }
//        
//        init(a: Intersection, b: Intersection, lanes: Int) {
//            self.a = a
//            self.b = b
//            self.lanes = lanes
//        }
//    }
//    
//    // Mark: Functions For City Generation
//    
//    class Generator {
//        
//        var delegate: CityGeneratorDelegate?
//        
//        func generateIntersections(count: Int, withinArea area: Vector2) -> NSMutableArray {
//            let array = NSMutableArray(capacity: count)
//            for i in 0..<count {
//                let id = i
//                let xCoor = Utils.random(min: 0, max: area.x)
//                let yCoor = Utils.random(min: 0, max: area.y)
//                array.add(Intersection(id: id, coor: (xCoor, yCoor)))
//                if let delegate = delegate, i % delegate.intervalSize == 0 {
//                    delegate.generateIntersectionPartialComplete(completedNodes: i, totalNodes: count)
//                }
//            }
//            return array
//        }
//        
//        func generateRoads(forIntersections array: inout NSMutableArray, connectionCount: Range) {
//            var numConnection = Array<Int>(repeating: 0, count: array.count)
//            
//            for i in 0..<numConnection.count {
//                numConnection[i] = Utils.random(min: 1, max: 3 + 1)
//            }
//            
//            for index in 0..<array.count {
//                let node = array[index] as! City.Intersection
//                
//                let roadCount = node.roads.count
//                let roadCountTarget = numConnection[index]
//                
//                
//                if roadCount >= roadCountTarget {
//                    continue
//                }
//                
//                //let nearest = intersectionsClosest(to: node, among: array)
//                
//                let nearest = array
//                
//                for _ in 0..<roadCountTarget {
//                    var foundIndex = false
//                    var idx = 0
//                    while !foundIndex {
//                        idx = Utils.random(min: 0, max: array.count)
//                        if idx != index {
//                            foundIndex = true
//                        }
//                    }
//                    
//                    let otherNode = nearest[idx] as! City.Intersection
//                    
//                    let otherIndex = array.index(of: otherNode)
//                    let otherRoadCount = otherNode.roads.count
//                    let otherRoadCountTarget = numConnection[otherIndex]
//                    
//                    if otherRoadCount >= otherRoadCountTarget {
//                        continue
//                    }
//                    
//                    let road = Road(a: node, b: otherNode, lanes: 1)
//                    node.roads.append(road)
//                    otherNode.roads.append(road)
//                    
//                }
//                
//                if let delegate = delegate, index % delegate.intervalSize == 0 {
//                    delegate.generateIntersectionPartialComplete(completedNodes: index, totalNodes: array.count)
//                }
//            }
//        }
//        
//        private func intersectionsClosest(to node: Intersection, among nodes: NSMutableArray) -> [Intersection] {
//            var array = nodes.sorted(by: { ($0 as! Intersection).distance(to: node) < ($1 as! Intersection).distance(to: node)} ) as! [City.Intersection]
//            array.removeFirst()
//            return array
//        }
//        
//    }
//
//}
//
