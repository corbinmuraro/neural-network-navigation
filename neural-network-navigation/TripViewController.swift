//
//  TripViewController.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 3/8/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Cocoa

class TripViewController: NSViewController {

    @IBOutlet weak var xStartTextField: NSTextField!
    @IBOutlet weak var yStartTextField: NSTextField!
    @IBOutlet var outputTextView: NSTextView!
    @IBAction func goButton(_ sender: NSButton) {
        runSimulation()
    }
    @IBAction func clearButton(_ sender: NSButton) {
        
    }
    @IBOutlet weak var batchCountTextField: NSTextField!
    @IBAction func batchGoButton(_ sender: NSButton) {
        let formatter = NumberFormatter()
        let count = formatter.number(fromUngrouped: batchCountTextField.stringValue)?.intValue ?? 1
        let shouldTrain = trainCheckBox.state == NSOnState
        let trainInterval = formatter.number(fromUngrouped: trainTextField.stringValue)?.intValue ?? 10
        let trainCount = formatter.number(fromUngrouped: trainCountTextField.stringValue)?.intValue ?? 10
        runSimulationInBatch(count: count, withTrainInterval: shouldTrain ? trainInterval : nil, trainCount: shouldTrain ? trainCount : nil)
    }
    @IBOutlet weak var trainCheckBox: NSButton!
    @IBOutlet weak var trainTextField: NSTextField!
    @IBOutlet weak var trainCountTextField: NSTextField!
    
    
    var cityBuilder: CityBuilder? { return DataSourse.shared.cityBuilder }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func runSimulation() {
        guard let cityBuilder = cityBuilder else { return }
        printToOutput(arg: "--date")
        cityBuilder.newTrip() { output in
            self.printToOutput(output)
        }
    }
    
    func runSimulationInBatch(count: Int, withTrainInterval interval: Int?, trainCount: Int?) {
        guard let cityBuilder = cityBuilder else { return }
        printToOutput(arg: "--date")
        var controller = BatchTripController()
        let trainer = NetworkTrainer(city: cityBuilder.city)
        DispatchQueue.global(qos: .userInitiated).async {
            cityBuilder.batchTrip(count: count, withTrainInterval: interval, trainCount: trainCount, trainer: trainer, controller: &controller, printer: {_ in}, completion: {
                DispatchQueue.main.async {
                    self.printToOutput("Distances:\n\(controller.distances)")
                    self.printToOutput("Steps taken:\n\(controller.stepsTakens)")
                }
            })
        }
        
    }
    
    func printToOutput(arg: String) {
        switch arg {
        case "--date": printToOutput("Output at \(Date()):")
        default: break
        }
    }
    func printToOutput(_ string: String) {
        let output = NSAttributedString(string: string + "\n")
        outputTextView.textStorage?.append(output)
    }
    
}
