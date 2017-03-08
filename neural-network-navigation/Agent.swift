//
//  Agent.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 3/8/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

/**
The "agent" that travels in the city along the path
 */
class Agent {
    
    var cityBuilder: CityBuilder
    var city: City { return cityBuilder.city }
    var network: FFNN { return cityBuilder.network }
    
    init(cityBuilder: CityBuilder) {
        self.cityBuilder = cityBuilder
    }
    
    var currentPos = Vector2.zero
    var startPos = Vector2.zero
    var endPos = Vector2.zero
    var endPosRelative = Vector2.zero
    
    /**
     Generate a random start point and and end point
     */
    func newTrip() {
        startPos = Vector2.random(max: city.size)
        endPos = Vector2.random(max: city.size)
    }
    
    /**
     Travels down the path each step
     */
    func runTrip() {
        currentPos = startPos
        while currentPos != endPos {
            let input = sense()
            guard let output = try? network.update(inputs: input) else { return }
            guard let dir = output.max() else { return }
            switch round(dir) {
            case 0: currentPos + Vector2.up
                case 0: currentPos + Vector2.up
                case 0: currentPos + Vector2.up
            }
        }
    }
    
    /**
     Update the input at the current step
     */
    func sense() -> [Float] {
        endPosRelative = endPos - currentPos
        let roads = city.intersection(at: currentPos)!.connections
        let up:Float = roads.up! ? 1:0
        let down:Float = roads.down! ? 1:0
        let left:Float = roads.left! ? 1:0
        let right:Float = roads.right! ? 1:0
        
        return [Float(endPosRelative.x), Float(endPosRelative.y), up, down, left, right]
    }
}












