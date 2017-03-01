//
//  CityBuilder.swift
//  neural-network-navigation
//
//  Created by Corbin Muraro on 2/24/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

class CityBuilder {
    
    var city: City
    
    init() {
        self.city = City()
    }
    
    func build(cityOfSize cityArea: Vector2, nodeCount: Int, delegate: CityGeneratorDelegate?, completion: () -> Void) {
        city = City()
        city.generate(cityArea: cityArea, nodeCount: nodeCount, delegate: delegate)
        let numNodes = city.nodes.count
        
        let network = FFNN(inputs: numNodes, hidden: 20, outputs: numNodes, learningRate: 1.0, momentum: 0.5, weights: nil, activationFunction: .Sigmoid, errorFunction: .crossEntropy(average: true))
        
        
        // Calls the completion() callback for the caller
        completion()
    }

    
    func trainNetwork() {
        // build array (input array) of arrays (paths) of Vector2 intersection coordinates
        var inputs = [[Vector2]]()
        var answers = [[Vector2]]()
        
        for i in city.nodes {
            inputs.append(([i.coor]))
//            answers.append(()) // append correct path
        }
            
            
//        let weights = try! network.train(inputs: inputs, answers: answers,
//                                         testInputs: testInputs, testAnswers: testAnswers,
//                                         errorThreshold: 0.1)
    }
    

}

struct Coord {
    var x: Int
    var y: Int
}
