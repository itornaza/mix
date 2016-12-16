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
        } else {
            self.clearResults()
        }
    }
    
    @IBAction func dextroseVolumeEC(_ sender: UITextField) {
        self.impossibleMix.isHidden = true
        if !(self.dextroseVolume.text?.isEmpty)! {
            self.calculateXylocaineVol()
        } else {
            self.clearResults()
        }
    }
    
    @IBAction func xylocainFlaconVolumeEC(_ sender: UITextField) {
        self.impossibleMix.isHidden = true
        if !(self.xylocaineFlaconVolume.text?.isEmpty)! {
            self.calculateXylocaineVol()
        } else {
            self.clearResults()
        }
    }
    
    //------------
    // Helpers
    //------------
    
    /*
                  | lt  | xylocaine(%) | xylocaine(lt)
     -------------------------------------------------
     xylocaine 2% | x   | 0.02         | 0.02 * x
     dextrose     | z   | 0.0          | 0.0
     mix          | x+z | y            | (x+z) * y
     
     
     Solve for the third column,
     
          z(lt) * y(%)
     x =  ------------ * 1000(ml)
          0.02 - y(%)
     
     or,
     
                         dextrose(lt) * mix(%)
     xylocaineVol(ml) =  --------------------- * 1000(ml)
                         xylocaine(%) - mix(%)
     
     */
    func calculateXylocaineVol() {
        // Set up variables for calculations
        let y = Double("0." + self.mixturePercentage.text!)! // Convert to decimal
        let z = Double(self.dextroseVolume.text!)! / 1000.0 // Convert to liters
        
        // Calculate mix volume
        if y < 0.02 { // Caution! y = 0.02 will cause division by zero
            
            // Calculate xylocaine volume and number of flacons
            let x = get_x(dextroseLiters: z, mixPercentage: y)
            let flaconVolume = Double(self.xylocaineFlaconVolume.text!)!
            let xFlacon = get_xFlacon(xylocaineVolume: x, flaconVolume: flaconVolume)
            
            // Display results
            self.xylocaineVol.text = "\(x) ml"
            self.numberOfFlacons.text = "\(xFlacon)"
            
        } else {
            self.impossibleMix.isHidden = false
            self.clearResults()
        }
    }
    
    func get_x(dextroseLiters: Double, mixPercentage: Double) -> Double {
        let z = dextroseLiters
        let y = mixPercentage
        let x = ((z * y) / (0.02 - y)) * 1000
        return Double(round(100 * x) / 100)
    }
    
    func get_xFlacon(xylocaineVolume: Double, flaconVolume: Double) -> Double {
        let x = xylocaineVolume
        let xFlacon = x / flaconVolume
        return Double(round(100 * xFlacon) / 100)
    }
    
    // Get the input from the mixture decimal format and convert it to percentage
    func getPercentage(decimalString: String) -> String{
        let doubleString = "." + decimalString
        let number = Double(doubleString)! * 100
        return "\(number)"
    }
    
    func configure() {
        // UI
        self.impossibleMix.isHidden = true
        
        // Gestures
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(UIInputViewController.dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
        
        // Delegates
        self.mixturePercentage.delegate = self
        self.dextroseVolume.delegate = self
        self.xylocaineFlaconVolume.delegate = self
        
        // Show the num pad
        self.mixturePercentage.keyboardType = UIKeyboardType.numberPad
        self.dextroseVolume.keyboardType = UIKeyboardType.numberPad
        self.xylocaineFlaconVolume.keyboardType = UIKeyboardType.numberPad
    }
    
    func clearResults() {
        self.xylocaineVol.text = ""
        self.numberOfFlacons.text = ""
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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
}

