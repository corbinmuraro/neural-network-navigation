//
//  Agent.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 3/8/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

protocol AgentTrainer: AgentDelegate {
    func shouldTrainNetwork() -> Bool
    func correctAnswer(currentPos: Vector2, endPos: Vector2) -> [Float]?
    func tripCompleted(withTrainingError error: Float?)
}

protocol AgentDelegate {
    func tripCompleted(withDistance distance: Int, stepsTaken: Int)
}

/**
The "agent" that travels in the city along the path
 */
class Agent {
    
    var cityBuilder: CityBuilder
    var city: City { return cityBuilder.city }
    var network: FFNN { return cityBuilder.network }
    
    var delegate: AgentDelegate?
    
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
        while !tripIsValid(start: startPos, end: endPos) {
            print("trip not valid")
            newTrip()
        }
    }
    
    /**
     Travels down the path each step
     */
    func runTrip(withTrainer trainer: AgentTrainer?, printer: (String) -> Void) {
        var error: Float? = nil
        //var dist: Int? = nil
        currentPos = startPos
        printer("currentPos: \(currentPos) (endPos: \(endPos))")
        var counter = city.nodes.count * 3
        var stepsTaken = 0
        while currentPos != endPos && counter > 0 {
            let input = sense()
            guard let output = try? network.update(inputs: input) else { return }
            if let trainer = trainer, trainer.shouldTrainNetwork() {
                guard let answer = trainer.correctAnswer(currentPos: currentPos, endPos: endPos) else { break }
                //print(answer)
                do {
                    error = try network.backpropagate(answer: answer)
                } catch {
                    //print(error)
                }
            }
            
            guard let dir = output.max() else { return }
            switch output.index(of: dir)! {
            case 0: currentPos += Vector2.up; printer("Going up")
            case 1: currentPos += Vector2.down; printer("Going down")
            case 2: currentPos += Vector2.left; printer("Going left")
            case 3: currentPos += Vector2.right; printer("Going right")
            default: break
            }
            if currentPos.isOutOf(bounds: city.size) {
                printer("Going out of bounds")
                break
            }
            counter -= 1
            stepsTaken += 1
        }
        printer("At end. currentPos: \(currentPos) (endPos: \(endPos))")
        let distance = endPos.distance(to: currentPos)
        #if DEBUG
            print("currentPos: \(currentPos), endPos: \(endPos)")
            print("Trip completed with distance: \(distance)")
        #endif
        delegate?.tripCompleted(withDistance: distance, stepsTaken: stepsTaken)
        if let trainer = trainer {
            if trainer.shouldTrainNetwork() {
                trainer.tripCompleted(withTrainingError: error)
            }
            trainer.tripCompleted(withDistance: distance, stepsTaken: stepsTaken)
        } else {
            trainer?.tripCompleted(withTrainingError: nil)
        }
    }
    
    /**
     Use the algorithm to test if the two points have a valid path
    */
    func tripIsValid(start: Vector2, end: Vector2) -> Bool {
        return Pathfinder().dijkstra(city: city, start: city.intersection(at: start)!, finish: city.intersection(at: end)!) != nil
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












