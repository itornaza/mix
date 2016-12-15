//
//  ViewController.swift
//  mix
//
//  Created by Ioannis Tornazakis on 13/12/16.
//  Copyright © 2016 polarbear.gr. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    //------------
    // Outlets
    //------------
    
    @IBOutlet weak var xylocaineVol: UILabel!
    @IBOutlet weak var mixturePercentage: UITextField!
    @IBOutlet weak var dextroseVolume: UITextField!
    @IBOutlet weak var xylocaineFlaconVolume: UITextField!
    @IBOutlet weak var numberOfFlacons: UILabel!
    @IBOutlet weak var impossibleMix: UILabel!
    @IBOutlet weak var mixturePercentageConfirmation: UILabel!
    
    //------------
    // Lifecycle
    //------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.calculateXylocaineVol()
    }
    
    //------------
    // Actions
    //------------
    
    @IBAction func mixturePerxentageEC(_ sender: UITextField) {
        self.impossibleMix.isHidden = true
        if !(self.mixturePercentage.text?.isEmpty)! {
            self.mixturePercentageConfirmation.text = "= " + self.getPercentage(decimalString: self.mixturePercentage.text!) + " %"
            self.calculateXylocaineVol()
        }
    }
    
    @IBAction func dextroseVolumeEC(_ sender: UITextField) {
        self.impossibleMix.isHidden = true
        if !(self.dextroseVolume.text?.isEmpty)! {
            self.calculateXylocaineVol()
        }
    }
    
    @IBAction func xylocainFlaconVolumeEC(_ sender: UITextField) {
        self.impossibleMix.isHidden = true
        if !(self.xylocaineFlaconVolume.text?.isEmpty)! {
            self.calculateXylocaineVol()
        }
    }
    
    //------------
    // Helpers
    //------------
    
    func configure() {
        
        // UI
        self.impossibleMix.isHidden = true
        
        // Delegates
        self.mixturePercentage.delegate = self
        self.dextroseVolume.delegate = self
        self.xylocaineFlaconVolume.delegate = self
        
        // Show the num pad
        self.mixturePercentage.keyboardType = UIKeyboardType.numberPad
        self.dextroseVolume.keyboardType = UIKeyboardType.numberPad
        self.xylocaineFlaconVolume.keyboardType = UIKeyboardType.numberPad
    }
    
    /// TODO: Write the formula from notebook
    func calculateXylocaineVol() {
        
        // Prepare variables
        var x = 0.0
        let y = Double("0." + self.mixturePercentage.text!)! // Convert to decimal
        let z = Double(self.dextroseVolume.text!)! / 1000.0 // Convert to liters
        
        // Calculate mix volume
        if y < 0.02 { // Caution! y = 0.02 will cause division by zero
            x = (((z * y) / (0.02 - y)) * 1000) // x in ml
        } else {
            self.impossibleMix.isHidden = false
        }
        let xFlacon = x / Double(self.xylocaineFlaconVolume.text!)!
        
        // Display results
        self.xylocaineVol.text = "\(Double(round(100 * x) / 100))"
        self.numberOfFlacons.text = "\(Double(round(100 * xFlacon) / 100))"
    }
    
    // Get the input fromm the mixture decimal format and convert it to percentage
    func getPercentage(decimalString: String) -> String{
        let doubleString = "." + decimalString
        let number = Double(doubleString)! * 100
        return "\(number)"
    }
    
    //----------------------
    // TextFieldDelegate
    //----------------------
    
    // Allow integers only
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let inverseSet = NSCharacterSet(charactersIn:"01234§56789").inverted
        let components = string.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        return string == filtered
    }
    
    // Dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
}

