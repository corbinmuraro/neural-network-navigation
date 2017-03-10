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
    func dijkstra(city:City, start: City.Intersection, finish: City.Intersection) -> City.Intersection? {
        typealias Intersection = City.Intersection
        
        // Check if it's next to each other
        if start.coor.distance(to: finish.coor) <= 1 { return nil }
        
        var intersections:[Intersection] = city.nodes.map({ $0 as! Intersection })
        //print(intersections)
        var distances = [Intersection:Double]() // empty dictionary with pairs of node / distance value for the graph
        var previousPaths = [Intersection:Intersection]() // empty array with list of nodes in the shortest path
        
        let currentIntersection = start
        
        // set starting values for the algorithm
        for intersection in intersections {
            distances[intersection] = Double.infinity
            previousPaths[intersection] = nil
        }
        
        // distance at starting intersection = 0
        distances[currentIntersection] = 0
        //print(distances)
        
        while (intersections.count > 0) {
            var closestNode:Intersection? = nil
            var distance = Double.infinity
            for intersection in intersections {
                if (closestNode == nil || distance > distances[intersection]!) {
                    distance = distances[intersection]!
                    closestNode = intersection
                    //print(closestNode)
                }
            }
            //print(distances)
            
            if (closestNode! == finish) {
                break
            }
            
            let nodeIndex = intersections.index(of: closestNode!)
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
                //print(distance)
                //print(closestNode ?? "...")
                if distance < distances[neighbor]! {
                    distances[neighbor]! = distance
                    previousPaths[neighbor] = closestNode!
                    //print(previousPaths)
                }
            }
            //print(previousPaths)
        }
        
        //print(previousPaths)
        //print(distances)
        var pathVertices = [finish]
        var child = finish
        print(previousPaths)
        while (child != start) {
            if let _child = previousPaths[child] {
                print(child.coor)
                child = _child
                pathVertices.append(child)
            } else {
                return nil
            }
        }
        
        return pathVertices[pathVertices.count - 2]
    }
    
    func fastPath(visited: inout [Vector2], city: City, start: City.Intersection, end: City.Intersection) -> Vector2 {
        var dir = (end.coor - start.coor).normalized()
        if checkPath(intersection: start, direction: dir, visited: &visited) {
            visited.append(start.coor + dir)
            return dir
        } else {
            let angle = start.coor.angle(to: end.coor)
            switch angle {
            case 0...90:
                if dir == Vector2.right { dir = Vector2.up }
                else { dir = Vector2.right }
            case 90...180:
                if dir == Vector2.left { dir = Vector2.up }
                else { dir = Vector2.left }
            case -90...0:
                if dir == Vector2.right { dir = Vector2.down }
                else { dir = Vector2.right }
            case -180 ... -90:
                if dir == Vector2.left { dir = Vector2.down }
                else { dir = Vector2.left }
            default:
                dir = Vector2.zero
            }
            
            if checkPath(intersection: start, direction: dir, visited: &visited) {
                visited.append(start.coor + dir)
                return dir
            } else {
                if dir == Vector2.up { dir = Vector2.down }
                if dir == Vector2.down { dir = Vector2.up }
                if dir == Vector2.left { dir = Vector2.right }
                if dir == Vector2.right { dir = Vector2.left }
                
                if checkPath(intersection: start, direction: dir, visited: &visited) {
                    visited.append(start.coor + dir)
                    return dir
                } else {
                    let original = (end.coor - start.coor).normalized()
                    if original == Vector2.up { dir = Vector2.down }
                    if original == Vector2.down { dir = Vector2.up }
                    if original == Vector2.left { dir = Vector2.right }
                    if original == Vector2.right { dir = Vector2.left }
                    
                    if checkPath(intersection: start, direction: dir, visited: &visited) {
                        visited.append(start.coor + dir)
                        return dir
                    } else {
                        return Vector2.zero
                    }
                }
            }
        }
        
    }
    
    private func checkPath(intersection: City.Intersection, direction: Vector2, visited: inout [Vector2]) -> Bool {
        if direction == Vector2.up {
            if let up = intersection.connections.up, visited.contains(intersection.coor) { return up } else { return false }
        } else if direction == Vector2.down {
            if let down = intersection.connections.down, visited.contains(intersection.coor) { return down } else { return false }
        } else if direction == Vector2.left {
            if let left = intersection.connections.left, visited.contains(intersection.coor) { return left } else { return false }
        } else if direction == Vector2.right {
            if let right = intersection.connections.right, visited.contains(intersection.coor) { return right } else { return false }
        } else { return false }
    }
    
}


