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
    
    func build(cityOfSize cityArea: Vector2, nodeCount: Int, completion: () -> Void) {
        city = City()
        city.generate(cityArea: cityArea, nodeCount: nodeCount)
        var numNodes = city.nodes.count
        
        //let network = FFNN(inputs: numNodes, hidden: 20, outputs: numNodes, learningRate: 1.0, momentum: 0.5, weights: nil, activationFunction: .Sigmoid, errorFunction: .crossEntropy(average: true))
        
        
        // Calls the completion() callback for the caller
        completion()
    }

    
    
    func getTrainingData() {
        
    }
    
    func trainNetwork() {
        
    }
}
