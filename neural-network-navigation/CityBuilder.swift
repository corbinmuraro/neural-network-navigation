//
//  CityBuilder.swift
//  neural-network-navigation
//
//  Created by Corbin Muraro on 2/24/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

// builds the physical
class CityBuilder {
    typealias Intersection = City.Intersection
    fileprivate(set) var city: City
    fileprivate(set) var numNodes: Int
    fileprivate(set) var network: FFNN!

    lazy var trainPaths = [Intersection]()
    lazy var testPaths = [Intersection]()
    
    init() {
        self.city = City(size: Vector2.zero)
        numNodes = city.nodes.count
        setupNetwork()
    }
    
    func build(cityArea: Vector2, delegate: CityGeneratorDelegate?, completion: () -> Void) {
        self.city = City(size: cityArea)
        city.generate(openRoadBias: 0.75, delegate: delegate)

        // Calls the completion() callback for the caller
        completion()
    }
    
    
    func setupNetwork() {
        network = FFNN(inputs: 6, hidden: 4, outputs: 4)
    }
    
    func newTrip(printer: (String) -> Void) {
        let agent = Agent(cityBuilder: self)
        agent.newTrip()
        agent.runTrip(withTrainer: nil, printer: printer)
    }
    
    func trainNetwork(count: Int, printer: (String) -> Void) {
        let agent = Agent(cityBuilder: self)
        let trainer = NetworkTrainer()
        for _ in 1...count {
            agent.newTrip()
            agent.runTrip(withTrainer: trainer, printer: printer)
        }
    }
}

class NetworkTrainer: AgentTrainer {
    
    var errors = [Float]()
    
    func shouldTrainNetwork() -> Bool {
        return true
    }
    func correctAnswer(currentPos: Vector2, endPos: Vector2) -> [Float] {
        
        // Incomplete Implementation
        return [Float]()
    }
    func tripCompleted(withTrainingError error: Float?) {
        if let error = error { errors.append(error) }
    }
    
}


