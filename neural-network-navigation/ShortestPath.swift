//
//  ShortestPath.swift
//  neural-network-navigation
//
//  Created by Corbin Muraro on 3/6/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

// INPUTS:  city, start intersection, end intersection
// OUTPUTS: dictionary with line segments building up the shortest path
func dijkstra(city:City, start: City.Intersection, finish: City.Intersection) -> [City.Intersection:City.Intersection] {
    
    let intersections = city.nodes
    var distances:[City.Intersection:Double] = [:] // empty dictionary with pairs of Intersection, Double
    var previousPaths:[City.Intersection:City.Intersection] = [:] // empty dictionary with pairs of Intersection, Double
    
    let currentIntersection: City.Intersection = intersections[0] as! City.Intersection
    
    // set starting values for the algorithm
    for intersection in intersections {
        guard let intersection = intersection as? City.Intersection else { continue }
        distances[intersection] = Double.infinity
        previousPaths[intersection] = nil
    }
    
    // distance at starting intersection = 0
    distances[currentIntersection] = 0
    
    while (intersections.count > 0) {
        var closestNode:City.Intersection? = nil
        var distance:Double = Double.infinity
        for intersection in intersections {
            guard let intersection = intersection as? City.Intersection else { continue }
            if (closestNode == nil || distance < distances[intersection]!) {
                distance = distances[intersection]!
                closestNode = intersection
            }
        }
        
        if (closestNode! == finish) {
            return previousPaths
        }
        
//        var nodeIndex:Int? = find(intersections, closestNode!)?
        let nodeIndex:Int? = intersections.index(of: closestNode!)
        intersections.remove(at: nodeIndex!)

        
      /*
        if (closestNode?.roads != nil && (closestNode?.roads.count)! > 0) {
            
            // closestNode?.roads?.each({(road:Road) -> Void? in
            for road:City.Road in (closestNode?.roads)! {
                
                if (road.a == closestNode) {
                    // use the road's 'b' vertex to determine distance
                    let distance = distances[closestNode!]! + closestNode!.distance(to: road.b)
                    if distance < distances[road.b]! {
                        distances[road.b]! = distance
                        previousPaths[road.b] = closestNode!
                    }
                }
                    
                else {
                    // use the road's 'a' vertex to determine distance
                    let distance = distances[closestNode!]! + closestNode!.distance(to: road.a)
                    if distance < distances[road.a]! {
                        distances[road.a]! = distance
                        previousPaths[road.a] = closestNode!
                    }
                }
                
                
            }
        }
 */
    }
    
    return previousPaths
}


