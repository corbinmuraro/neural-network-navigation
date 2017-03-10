//
//  ViewController.swift
//  neural-network-navigation
//
//  Created by Austin Chau on 2/22/17.
//  Copyright © 2017 Psych186B. All rights reserved.
//

import Cocoa

class SetupViewController: NSViewController {
    
    // Mark: IBOutlets
    @IBOutlet weak var xSizeTextField: NSTextField!
    @IBOutlet weak var ySizeTextField: NSTextField!
    @IBOutlet weak var openRoadBiasTextField: NSTextField!
    @IBOutlet weak var loadingLabel: NSTextField!
    @IBOutlet weak var debugTextView: NSTextView!
    @IBOutlet weak var generateButton: NSButton!

    @IBAction func generateCity(_ sender: NSButton) {
        loadingLabel.stringValue = "Loading"
        loadingLabel.isHidden = false
        generateButton.isEnabled = false
        
        let formatter = NumberFormatter()
        let xSize = formatter.number(fromUngrouped: xSizeTextField.stringValue)?.intValue ?? 10
        let ySize = formatter.number(fromUngrouped: ySizeTextField.stringValue)?.intValue ?? 10
        let openRoadBias = formatter.number(fromUngrouped: openRoadBiasTextField.stringValue)?.doubleValue ?? 1
        generateCity(ofSize: Vector2(x: xSize, y: ySize), openRoadBias: openRoadBias, completion: {
            self.loadingLabel.stringValue = "Done"
            self.generateButton.isEnabled = true
            self.printToDebugView()
        })
        
    }
    
    // Mark: View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingLabel.isHidden = true
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // Mark: Variables
    
    var cityBuilder: CityBuilder? { return DataSourse.shared.cityBuilder }
    var cityGeneratorDelegate: CityGeneratorDelegate?
    
    // Mark: Internal Functions
    
    private func generateCity(ofSize size: Vector2, openRoadBias: Double, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            DataSourse.shared.newCityBuilder()
            self.cityBuilder?.build(cityArea: size, openRoadBias: openRoadBias, delegate: self, completion: {
                
            })
            // When generation is done
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func printToDebugView(refresh: Bool = false) {
        let dividerString = "---------------------------------\nOutput at \(Date()):\n"
        debugTextView.textStorage?.append(NSAttributedString(string: dividerString))
        
        if let city = cityBuilder?.city {
            var output = ""
            output.append("City generated\n")
            output.append("City Size: \(city.xLim) × \(city.yLim)\n")
            output.append("Node Count: \(city.nodes.count)\n")
            
            debugTextView.textStorage?.append(NSAttributedString(string: output))
        } else {
            debugTextView.textStorage?.append(NSAttributedString(string: DebugViewOutput.noCity.rawValue))
        }
        
        debugTextView.textStorage?.append(NSAttributedString(string: "---------------------------------\n\n"))
        
    }
    
    enum DebugViewOutput: String, Error {
        case noCity = "Error: CityBuilder Do Not Have City"
        
    }
    
}

extension SetupViewController: CityGeneratorDelegate {
    internal func intervalSize() -> Int {
        return 10
    }

    
    func generateIntersectionPartialComplete(completedNodes: Int, totalNodes: Int) {
        DispatchQueue.main.async {
            self.loadingLabel.stringValue = "Generating intersections: \(completedNodes) out of \(totalNodes) nodes completed."
        }
    }
    func generateConnectionsPartialComplete(completedNodes: Int, totalNodes: Int) {
        DispatchQueue.main.async {
            self.loadingLabel.stringValue = "Generating connections: \(completedNodes) out of \(totalNodes) nodes completed."
        }
    }
    
}

