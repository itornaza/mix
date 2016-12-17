//
//  ViewController.swift
//  mix
//
//  Created by Ioannis Tornazakis on 13/12/16.
//  Copyright © 2016 polarbear.gr. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // Global variables
    var xylocaineConcentration: Double = 0.02 // Aligned with the default selection
    
    //------------
    // Outlets
    //------------
    
    @IBOutlet weak var mixturePercentage: UITextField!
    @IBOutlet weak var dextroseVolume: UITextField!
    @IBOutlet weak var impossibleMix: UILabel!
    @IBOutlet weak var mixturePercentageConfirmation: UILabel!
    @IBOutlet weak var xylocaineVolume: UILabel!
    
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
    
    @IBAction func xylocaineConcentration(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.xylocaineConcentration = 0.01
            break
        default:
            self.xylocaineConcentration = 0.02
            break
        }
        self.calculateXylocaineVol()
    }
    
    //------------
    // Helpers
    //------------
    
    /*
                  | lt  | xylocaine(%) | xylocaine(lt)
     -------------------------------------------------
     xylocaine 2% | x   | w            | w * x
     dextrose     | z   | 0.0          | 0.0
     mix          | x+z | y            | (x+z) * y
     
     
     Solve for the third column,
     
          z(lt) * y(%)
     x =  ------------ * 1000(ml)
          w(%) - y(%)
     
     or,
     
                         dextrose(lt) * mix(%)
     xylocaineVol(ml) =  --------------------- * 1000(ml)
                         xylocaine(%) - mix(%)
     
     */
    func calculateXylocaineVol() {
        // Set up variables for calculations
        let y = Double("0." + self.mixturePercentage.text!)! // Convert to decimal
        let z = Double(self.dextroseVolume.text!)! / 1000.0 // Convert to liters
        let w = self.xylocaineConcentration
        
        // Calculate mix volume
        if y < w { // Caution! y = 0.02 will cause division by zero
            
            // Calculate xylocaine volume and number of flacons
            let x = get_x(dextroseLiters: z, mixPercentage: y, xylocaineConcentration: w)
            
            // Display results
            self.xylocaineVolume.text = "\(x) ml"
            
        } else {
            self.impossibleMix.isHidden = false
            self.clearResults()
        }
    }
    
    func get_x(dextroseLiters: Double, mixPercentage: Double, xylocaineConcentration: Double) -> Double {
        // Set up variables
        let z = dextroseLiters
        let y = mixPercentage
        let w = xylocaineConcentration
        
        // Calculate
        let x = ((z * y) / (w - y)) * 1000
        return Double(round(100 * x) / 100)
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
        
        // Segmented control
        let attr = NSDictionary(object: UIFont(
            name: "HelveticaNeue-Bold", size: 17.0)!, forKey: NSFontAttributeName as NSCopying
        )
        UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
        // Gestures
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(UIInputViewController.dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
        
        // Delegates
        self.mixturePercentage.delegate = self
        self.dextroseVolume.delegate = self
        
        // Show the num pad
        self.mixturePercentage.keyboardType = UIKeyboardType.numberPad
        self.dextroseVolume.keyboardType = UIKeyboardType.numberPad
    }
    
    func clearResults() {
        self.xylocaineVolume.text = ""
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

