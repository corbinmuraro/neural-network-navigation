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
            output.append("Roads:\n")
            // Roads
            if node.connections.up == true {
                guard let upNode = city.intersection(at: node.coor + Vector2.up) else { return }
                output.append("\tRoads going up to: \(upNode.id) (\(upNode.coor.x),\(upNode.coor.y))\n")
            }
            if node.connections.down == true {
                guard let downNode = city.intersection(at: node.coor + Vector2.down) else { return }
                output.append("\tRoads going down to: \(downNode.id) (\(downNode.coor.x),\(downNode.coor.y))\n")
            }
            if node.connections.left == true {
                guard let leftNode = city.intersection(at: node.coor + Vector2.left) else { return }
                output.append("\tRoads going left to: \(leftNode.id) (\(leftNode.coor.x),\(leftNode.coor.y))\n")
            }
            if node.connections.right == true {
                guard let rightNode = city.intersection(at: node.coor + Vector2.right) else { return }
                output.append("\tRoads going right to: \(rightNode.id) (\(rightNode.coor.x),\(rightNode.coor.y))\n")
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
