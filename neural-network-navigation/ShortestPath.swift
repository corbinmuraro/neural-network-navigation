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
    
    var intersections = city.nodes
    var distances:[City.Intersection:Double] = [:] // empty dictionary with pairs of Intersection, Double
    var previousPaths:[City.Intersection:City.Intersection] = [:] // empty dictionary with pairs of Intersection, Double
    
    var currentIntersection: City.Intersection = intersections[0]
    
    
    // set starting values for the algorithm
    for intersection:City.Intersection in intersections {
        distances[intersection] = Double.infinity
        previousPaths[intersection] = nil
    }
    
    // distance at starting intersection = 0
    distances[currentIntersection] = 0
    
    while (intersections.count > 0) {
        var closestNode:City.Intersection? = nil
        var distance:Double = Double.infinity
        for intersection:City.Intersection in intersections {
            if (closestNode == nil || distance < distances[intersection]!) {
                distance = distances[intersection]!
                closestNode = intersection
            }
        }
        
        if (closestNode! == finish) {
            return previousPaths
        }
        
        var nodeIndex:Int? = find(intersections, closestNode!)?
        intersections.remove(at: nodeIndex!)
        
        if (closestNode?.roads != nil && closestNode?.roads?.count > 0) {
            
            // closestNode?.roads?.each({(road:Road) -> Void? in
            for road:City.Road in closestNode?.roads {
                
                if (road.startIntersection = closestNode) {
                    // use the road's 'end' vertex to determine distance
                    var distance = distances[closestNode!]! + closestNode!.distanceToVertex(road.end)!.distance
                    if distance < distances[road.destinationVertex] {
                        distances[road.destinationVertex] = distance
                        previousPaths[road.end] = closestNode!
                    }
                }
                    
                else {
                    // use the road's 'start' vertex to determine distance
                    var distance = distances[closestNode!]! + closestNode!.distanceToVertex(road.start)!.distance
                    if distance < distances[road.destinationVertex] {
                        distances[road.destinationVertex] = distance
                        previousPaths[road.start] = closestNode!
                    }
                }
                
                
            }
        }
    }
    
    return previousPaths
}
