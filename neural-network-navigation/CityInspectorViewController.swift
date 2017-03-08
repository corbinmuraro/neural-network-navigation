//
//  CityInspectorViewController.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 3/1/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Cocoa

class CityInspectorViewController: NSViewController {
    
    var cityBuilder: CityBuilder? { return DataSourse.shared.cityBuilder }

    @IBOutlet weak var viewNodeTextField: NSTextField!
    @IBAction func viewNode(_ sender: NSButtonCell) {
        let formatter = NumberFormatter()
        let nodeID = formatter.number(fromUngrouped: viewNodeTextField.stringValue)?.intValue
        
        var output = ""
        if let city = cityBuilder?.city, let nodeID = nodeID, let node = city.nodes[nodeID] as? City.Intersection {
            output.append("For node: \(nodeID)\n")
            output.append("Node ID: \(node.id)\n")
            output.append("Node Coordinates: (\(node.coor.x),\(node.coor.y))\n")
            output.append("Roads Count: \(node.roads.count)\n")
            for road in node.roads {
                output.append("\tConnecting between: \(road.a.id) (\(road.a.coor.x),\(road.a.coor.y)) and \(road.b.id) (\(road.b.coor.x),\(road.b.coor.y))\n")
            }
        } else {
            output.append("Error: Node invalid.\n")
        }
        printToOutput(string: output)
    }
    
    
    @IBOutlet weak var outputTextField: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func printToOutput(string: String, refresh: Bool = false) {
        let dividerString = "---------------------------------\nOutput at \(Date()):\n"
        outputTextField.textStorage?.append(NSAttributedString(string: dividerString))
        outputTextField.textStorage?.append(NSAttributedString(string: string))
        
        outputTextField.textStorage?.append(NSAttributedString(string: "---------------------------------\n\n"))
    }
    
}
