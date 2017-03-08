//
//  Hopfield.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 3/7/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

class Hopfield {
    
    func build(nodeCount: Int) {
        let city = City()
        city.generate(cityArea: (10,10), nodeCount: nodeCount, delegate: nil)
        
        let network = Matrix(rows: nodeCount, columns: nodeCount)
        
        for column in 0..<nodeCount {
            for row in 0..<nodeCount {
                network[column, row] = Random.numberFromZeroToOne()
            }
        }
        
    }
    
}
