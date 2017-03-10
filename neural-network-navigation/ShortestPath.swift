//
//  ShortestPath.swift
//  neural-network-navigation
//
//  Created by Corbin Muraro on 3/6/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

class Pathfinder {
    // INPUTS:  city, start intersection, end intersection
    // OUTPUTS: dictionary with line segments building up the shortest path
    func dijkstra(city:City, start: City.Intersection, finish: City.Intersection) -> City.Intersection {
        typealias Intersection = City.Intersection
        
        var intersections:[Intersection] = city.nodes.map({ $0 as! Intersection })
        var distances:[Intersection:Double] = [:] // empty dictionary with pairs of node / distance value for the graph
        var previousPaths:[Intersection:Intersection] = [:] // empty array with list of nodes in the shortest path
        
        let currentIntersection: Intersection = intersections[0]
        
        // set starting values for the algorithm
        for intersection in intersections {
            distances[intersection] = Double.infinity
            previousPaths[intersection] = nil
        }
        
        // distance at starting intersection = 0
        distances[currentIntersection] = 0
        
        while (intersections.count > 0) {
            var closestNode:City.Intersection? = nil
            var distance:Double = Double.infinity
            for intersection in intersections {
                if (closestNode == nil || distance < distances[intersection]!) {
                    distance = distances[intersection]!
                    closestNode = intersection
                }
            }
            
            if (closestNode! == finish) {
                break
            }
            
            let nodeIndex:Int? = intersections.index(of: closestNode!)
            intersections.remove(at: nodeIndex!)
            
            var neighbors = [Intersection]()
            if let up = closestNode?.connections.up, up {
                neighbors.append(city.intersection(at: closestNode!.coor + Vector2.up)!)
            }
            if let down = closestNode?.connections.down, down {
                neighbors.append(city.intersection(at: closestNode!.coor + Vector2.down)!)
            }
            if let left = closestNode?.connections.left, left {
                neighbors.append(city.intersection(at: closestNode!.coor + Vector2.left)!)
            }
            if let right = closestNode?.connections.right, right {
                neighbors.append(city.intersection(at: closestNode!.coor + Vector2.right)!)
            }
            
            for neighbor in neighbors {
                let distance = distances[closestNode!]! + 1 // assuming weight of all roads is 1
                if distance < distances[neighbor]! {
                    distances[neighbor]! = distance
                    previousPaths[neighbor] = closestNode!
                }
            }
        }
        
        var pathVertices:[Intersection] = [finish]
        var child = finish
        while (child != start) {
            child = previousPaths[child]!
            pathVertices.append(child)
        }
        
        return pathVertices[pathVertices.count - 2]
    }
    
}


