//
//  TrainViewController.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 3/9/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Cocoa

class TrainViewController: NSViewController {

    @IBOutlet weak var timesTextField: NSTextField!
    @IBAction func goButton(_ sender: NSButton) {
        run()
    }
    @IBOutlet var outputTextView: NSTextView!
    
    var cityBuilder: CityBuilder? { return DataSourse.shared.cityBuilder }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func run() {
        guard let cityBuilder = cityBuilder else { return }
        printToOutput(arg: "--date")
        let formatter = NumberFormatter()
        let times = formatter.number(fromUngrouped: timesTextField.stringValue)?.intValue ?? 1000
        cityBuilder.trainNetwork(count: times, printer: { output in
            self.printToOutput(output)
        })
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
