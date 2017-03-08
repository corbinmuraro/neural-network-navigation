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
    
    var cityBuilder: CityBuilder? { return DataSourse.shared.cityBuilder }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func runSimulation() {
        guard let cityBuilder = cityBuilder else { return }
        printToOutput(arg: "--date")
        cityBuilder.newTrip() { output in
            printToOutput(output)
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
