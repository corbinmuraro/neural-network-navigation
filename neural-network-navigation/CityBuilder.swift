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
    
    func build(cityArea: Vector2, openRoadBias: Double, delegate: CityGeneratorDelegate?, completion: () -> Void) {
        self.city = City(size: cityArea)
        city.generate(openRoadBias: openRoadBias, delegate: delegate)

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
        let trainer = NetworkTrainer(city: city)
        for _ in 1...count {
            print("new Trip")
            agent.newTrip()
            agent.runTrip(withTrainer: trainer, printer: printer)
            trainer.visited.removeAll()
        }
        printer("Errors of all training trials")
        printer("\(trainer.errors)")
    }
}

class NetworkTrainer: AgentTrainer {
    
    var errors = [Float]()
    var city: City
    var useFastPath = false
    var visited = [Vector2]()
    
    init(city: City) { self.city = city }
    
    func shouldTrainNetwork() -> Bool {
        return true
    }
    func correctAnswer(currentPos: Vector2, endPos: Vector2) -> [Float]? {
        let pathfinder = Pathfinder()
        if let start = city.intersection(at: currentPos), let end = city.intersection(at: endPos) {
            var answer: [Float] = [0,0,0,0]
            
            var nextStep: City.Intersection
            if useFastPath {
                let dir = pathfinder.fastPath(visited: &visited, city: city, start: start, end: end)
                if dir != Vector2.zero {
                    nextStep = city.intersection(at: currentPos + dir)!
                } else {
                    print("no path"); return nil
                }
            } else {
                guard let _nextStep = pathfinder.dijkstra(city: city, start: start, finish: end) else { print("no Answer"); return nil }
                nextStep = _nextStep
            }
            let nextCoor = nextStep.coor
            let dir = nextCoor - currentPos
            if dir == Vector2.up {
                answer[0] = 1
            } else if dir == Vector2.down {
                answer[1] = 1
            } else if dir == Vector2.left {
                answer[2] = 1
            } else if dir == Vector2.right {
                answer[3] = 1
            } else {
                print("correctAnswer can't get a direction")
            }
            return answer
        } else {
            return nil
        }
    }
    func tripCompleted(withTrainingError error: Float?) {
        if let error = error { errors.append(error) }
    }
    
}


