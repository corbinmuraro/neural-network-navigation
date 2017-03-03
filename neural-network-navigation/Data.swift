//
//  Data.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 3/1/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Foundation

class DataSourse {
    
    static var shared = DataSourse()
    
    private init() { }
    
    var cityBuilder: CityBuilder?
    
}
