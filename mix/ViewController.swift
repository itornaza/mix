//
//  ViewController.swift
//  mix
//
//  Created by Ioannis Tornazakis on 13/12/16.
//  Copyright © 2016 polarbear.gr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //------------
    // Globals
    //------------
    var xylocaineConcentration: Double = 0.02 // Aligned with the default selection
    let defaultXylocaineSelector: Int = 1
    let defaultDextroseVolume = "250"
    let defaultMixturePercentage = "0.5"
    let resetDextroseVolume = "0"
    let resetMixturePercentage = "0.0"
    let xylocaineSelectorID = "xylocaine_selector"
    let dextroseVolumeID = "dextrose_volume"
    let mixturePercentageID = "mixture_percentage"
    
    //------------
    // Outlets
    //------------
    
    @IBOutlet weak var xylocaineSelector: UISegmentedControl!
    @IBOutlet weak var dextroseVolume: UITextField!
    @IBOutlet weak var impossibleMix: UILabel!
    @IBOutlet weak var mixtrurePercentage: UITextField!
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var xylocaineVolume: UILabel!
    @IBOutlet weak var instructions: UITextView!
    
    //------------
    // Lifecycle
    //------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.checkAndCalculate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.saveInput()
    }
    
    //------------
    // Actions
    //------------
    
    @IBAction func mixturePerxentageEC(_ sender: UITextField) {
        self.checkAndCalculate()
    }
    
    @IBAction func dextroseVolumeEC(_ sender: UITextField) {
        self.checkAndCalculate()
    }
    
    @IBAction func xylocaineConcentration(_ sender: UISegmentedControl) {
        self.getXylocaineConcentration(index: sender.selectedSegmentIndex)
        self.checkAndCalculate()
    }
    
    @IBAction func reset(_ sender: UIButton) {
        self.xylocaineSelector.selectedSegmentIndex = 1
        self.dextroseVolume.text = self.resetDextroseVolume
        self.mixtrurePercentage.text = self.resetMixturePercentage
        self.clearResults()
    }
        
}
