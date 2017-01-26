//
//  ViewController.swift
//  mix
//
//  Created by Ioannis Tornazakis on 13/12/16.
//  Copyright © 2016 polarbear.gr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //---------------------------
    // MARK: - Class Properties
    //---------------------------
    
    enum lidocaineSolution: Int {
        case onePerCent = 0, twoPerCent
    }
    
    enum lidocaineConcentrationValue: Double {
        case onePerCent = 0.01
        case twoPerCent = 0.02
    }
    
    //----------------------
    // MARK: - Properties
    //----------------------
    
    var lidocaineConcentration: Double = 0.0
    var impossibleMixPrefix = "Impossible mix, cannot exceed "
    
    // Constants
    let defaultLidocaineSelector: Int = 1
    let defaultWaterVolume = "250"
    let defaultMixturePercentage = "0.5"
    let resetWaterVolume = "0"
    let resetMixturePercentage = "0.0"
    let lidocaineSelectorID = "lidocaine_selector"
    let waterVolumeID = "water_volume"
    let mixturePercentageID = "mixture_percentage"
    
    //--------------------
    // MARK: - Outlets
    //--------------------
    
    @IBOutlet weak var lidocaineSelector: UISegmentedControl!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var waterVolume: UITextField!
    @IBOutlet weak var impossibleMix: UILabel!
    @IBOutlet weak var mixtrurePercentage: UITextField!
    @IBOutlet weak var lidocaineConcentrationLabel: UILabel!
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var lidocaineVolume: UILabel!
    @IBOutlet weak var instructions: UITextView!
    
    //--------------------
    // MARK: - Lifecycle
    //--------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.checkAndCalculate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.saveInput()
    }
    
    //--------------------
    // MARK: - Actions
    //--------------------
    
    @IBAction func mixturePerxentageEC(_ sender: UITextField) {
        self.checkAndCalculate()
    }
    
    @IBAction func waterVolumeEC(_ sender: UITextField) {
        self.checkAndCalculate()
    }
    
    @IBAction func lidocaineConcentration(_ sender: UISegmentedControl) {
        self.getLidocaineConcentration(index: sender.selectedSegmentIndex)
        self.checkAndCalculate()
    }
    
    @IBAction func reset(_ sender: UIButton) {
        self.lidocaineSelector.selectedSegmentIndex = 1
        self.waterVolume.text = self.resetWaterVolume
        self.mixtrurePercentage.text = self.resetMixturePercentage
        self.clearResults()
    }
        
}
