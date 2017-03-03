//
//  CityInspectorViewController.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 3/1/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Cocoa

class CityInspectorViewController: NSViewController {
    
    var dataSource: CityBuilder?

    @IBOutlet weak var viewNodeTextField: NSTextField!
    @IBAction func viewNode(_ sender: NSButtonCell) {
        
    }
    
    
    @IBOutlet weak var outputTextField: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    private func printToOutput(refresh: Bool = false) {
        let dividerString = "---------------------------------\nOutput at \(Date()):\n"
        outputTextField.textStorage?.append(NSAttributedString(string: dividerString))
        
        if let city = cityBuilder?.city {
            var output = ""
            output.append("For node ")
            output.append("City Size: \(city.area.x) × \(city.area.y)\n")
            output.append("Node Count: \(city.nodes.count)\n")
            
            debugTextView.textStorage?.append(NSAttributedString(string: output))
        } else {
            debugTextView.textStorage?.append(NSAttributedString(string: DebugViewOutput.noCity.rawValue))
        }
        
        debugTextView.textStorage?.append(NSAttributedString(string: "---------------------------------\n\n"))
    }
    
}
