//
//  ViewController.swift
//  mix
//
//  Created by Ioannis Tornazakis on 13/12/16.
//  Copyright © 2016 polarbear.gr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Outlets
    @IBOutlet weak var xylocaineVol: UILabel!
    @IBOutlet weak var mixturePercentage: UITextField!
    @IBOutlet weak var dextroseVolume: UITextField!
    @IBOutlet weak var xylocaineFlaconVolume: UITextField!
    @IBOutlet weak var numberOfFlacons: UILabel!
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculateXylocaineVol()
    }
    
    // Actions
    @IBAction func mixtureVolumeEC(_ sender: UITextField) {
        self.calculateXylocaineVol()
    }
    
    @IBAction func dextroseVolumeEC(_ sender: UITextField) {
        self.calculateXylocaineVol()
    }
    
    @IBAction func xylocainFlaconVolumeEC(_ sender: UITextField) {
        self.calculateXylocaineVol()
    }
    
    // Helpers
    func calculateXylocaineVol() {
        let y = Double(self.mixturePercentage.text!)! / 100.0 // Convert to decimal
        let z = Double(self.dextroseVolume.text!)! / 1000.0 // Convert to liters
        
        // TODO: Check for division by zero
        let x = (((z * y) / (0.02 - y)) * 1000)
        let xFlacon = x / Double(self.xylocaineFlaconVolume.text!)!

        self.xylocaineVol.text = "\(Double(round(100 * x) / 100))"
        self.numberOfFlacons.text = "\(Double(round(100 * xFlacon) / 100))"
    }
}

