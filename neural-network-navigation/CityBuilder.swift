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
    fileprivate(set) var network: FFNN

    lazy var trainPaths = [Intersection]()
    lazy var testPaths = [Intersection]()
    
    init() {
        self.city = City(size: Vector2.zero)
        numNodes = city.nodes.count
        network = FFNN(inputs: numNodes, hidden: 20, outputs: numNodes, learningRate: 1.0, momentum: 0.5, weights: nil, activationFunction: .Sigmoid, errorFunction: .crossEntropy(average: true))
        
        
        //build(cityArea: Vector2(x: 50, y: 50), delegate: nil, completion: trainNetwork)

        //var result = dijkstra(city: city, start: city.nodes[0] as! City.Intersection, finish: city.nodes[city.nodes.count-1] as! City.Intersection)
    }
    
    func build(cityArea: Vector2, delegate: CityGeneratorDelegate?, completion: () -> Void) {
        self.city = City(size: cityArea)
        city.generate(openRoadBias: 0.75, delegate: delegate)

        // Calls the completion() callback for the caller
        completion()
    }
    
    func trainNetwork() {
        print("\nTraining Neural Network. . .")

//        var count = 0;
//        for index in 1...numNodes {
//            if ((numNodes - index) % 10) == 0 {
//                
//                count += 1;
//            }
//        }
//        
//        // build array (input array) of arrays (paths) of Vector2 intersection coordinates
//        var trainPaths = [[Intersection]]()
//        var testPaths = [[Intersection]]()
//    
//        for i in city.nodes {
////            inputs.append([i.coor])
//        }
//        
//        
//        //        let weights = try! network.train(inputs: inputs, answers: answers,
//        //                                         testInputs: testInputs, testAnswers: testAnswers,
//        //                                         errorThreshold: 0.1)
//        
//        do {
//            print("\nBefore training:")
//            var errorSum: Float = 0
//            var correct: Float = 0
//            var incorrect: Float = 0
//            for (index, image) in self.testImages.enumerate() {
//                let outputArray = try self.network.update(inputs: image)
//                if let outputLabel = self.outputToLabel(outputArray) {
//                    if outputLabel == self.testLabels[index] {
//                        correct += 1
//                    } else {
//                        incorrect += 1
//                    }
//                } else {
//                    incorrect += 1
//                }
//                let answerArray = testAnswers[index]
//                errorSum += self.calculateError(output: outputArray, answer: answerArray)
//            }
//            let percent = correct * 100 / (correct + incorrect)
//            print("Error sum: \(errorSum)")
//            print("Correct: \(Int(correct))")
//            print("Incorrect: \(Int(incorrect))")
//            print("Accuracy: \(percent)%")
//            
//            var epoch = 1
//            while true {
//                print("\nEpoch \(epoch): Learning rate \(self.network.learningRate)")
//                for (index, image) in self.trainImages.enumerate() {
//                    try self.network.update(inputs: image)
//                    let answer = trainAnswers[index]
//                    try self.network.backpropagate(answer: answer)
//                }
//                var errorSum: Float = 0
//                var correct: Float = 0
//                var incorrect: Float = 0
//                for (index, image) in self.testImages.enumerate() {
//                    let outputArray = try self.network.update(inputs: image)
//                    if let outputLabel = self.outputToLabel(outputArray) {
//                        if outputLabel == self.testLabels[index] {
//                            correct += 1
//                        } else {
//                            incorrect += 1
//                        }
//                    } else {
//                        incorrect += 1
//                    }
//                    let answerArray = testAnswers[index]
//                    errorSum += self.calculateError(output: outputArray, answer: answerArray)
//                }
//                let percent = correct * 100 / (correct + incorrect)
//                print("Error sum: \(errorSum)")
//                print("Correct: \(Int(correct))")
//                print("Incorrect: \(Int(incorrect))")
//                print("Accuracy: \(percent)%")
//                self.network.learningRate *= 0.75
//                self.network.momentumFactor *= 0.75
//                if percent > 98.0 || epoch == 10 {
//                    self.network.writeToFile("handwriting-ffnn")
//                    break
//                }
//                epoch += 1
//            }
//        } catch {
//            print(error)
//        }
//    }
//        
//    func calculateError(output: [Float], answer: [Float]) -> Float {
//        var error: Float = 0
//        for (index, element) in output.enumerated() {
//            error += abs(element - answer[index])
//        }
//        return error
    }
}


