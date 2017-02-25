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
        city = City()
        city.generate(cityArea: (10,10), nodeCount: 20)
        var numNodes = city.nodes.count
        
        let network = FFNN(inputs: numNodes, hidden: 20, outputs: numNodes, learningRate: 1.0, momentum: 0.5, weights: nil, activationFunction: .Sigmoid, errorFunction: .crossEntropy(average: true))
    }
    

    
    
    func getTrainingData() {
        
    }
    
    func trainNetwork() {
        
    }
}
