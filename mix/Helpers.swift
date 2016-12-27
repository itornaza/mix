//
//  Helpers.swift
//  mix
//
//  Created by Ioannis Tornazakis on 27/12/2016.
//  Copyright © 2016 polarbear.gr. All rights reserved.
//

import UIKit

extension ViewController {
    
    // Get xylocaine concentration from the segment control
    func getXylocaineConcentration(index: Int) {
        switch index {
        case 0:
            self.xylocaineConcentration = 0.01
            break
        default:
            self.xylocaineConcentration = 0.02
            break
        }
    }
    
    // Check if there is an empty or zero
    func fieldsAreValid() -> Bool {
        if (self.dextroseVolume.text?.isEmpty)! || (self.mixtrurePercentage.text?.isEmpty)! {
            return false
        } else {
            return true
        }
    }
    
    func checkAndCalculate() {
        // Update the xylocaine percentage on the result title regardless of the checks
        self.resultTitle.text = "Lidocaine " + "\(Double(self.xylocaineConcentration * 100))" + "%"
        
        // Reset the impossible mix each time
        self.impossibleMix.isHidden = true
        
        // If all fields are valid proceed to calcutions
        if self.fieldsAreValid() {
            self.calculationWrapper()
        } else {
            self.clearResults()
        }
    }
    
    /// Handles all calculations input values space and boundary cases for division by zero and impossible mixtures
    /// with greater concentrations than the starting xylocaine solution
    func calculationWrapper() {
        // Set up variables for calculations, validation is already done so safely unwrap text fields
        let y = Double(self.mixtrurePercentage.text!)! / 100 // Convert to decimal
        let z = Double(self.dextroseVolume.text!)! / 1000.0 // Convert to liters
        let w = self.xylocaineConcentration
        
        // Examine all possible values of input fields and calculate
        if Double(self.dextroseVolume.text!) == 0.0 && Double(self.mixtrurePercentage.text!) == 0.0 {
            // Both values are zero after a reset and off/on of the app
            self.clearResults()
        } else if Double(self.dextroseVolume.text!) == 0.0 {
            // Check if the dextrose volume is zero
            self.instructions.text = "Hey, some water for injection to mix with?"
            self.instructions.isHidden = false
        } else if Double(self.mixtrurePercentage.text!) == 0.0 {
            // Check if the mixture percentage is zero
            self.instructions.text = "Well, it seems that you do not need a mix for that"
            self.instructions.isHidden = false
        } else if y < w { // Caution! the xylocaine concentration value will cause division by zero
            // Calculate xylocaine volume
            let x = self.calculate(dextroseLiters: z, mixPercentage: y, xylocaineConcentration: w)
            self.xylocaineVolume.text = "\(x) ml"
            self.displayResults(xylocaineVolume: x)
        } else {
            // The final mix cannot have greater xylocaine concentration!
            self.impossibleMix.text! = "impossible mix, cannot exceed \(Double(self.xylocaineConcentration * 100))%"
            self.impossibleMix.isHidden = false
            self.clearResults()
        }
    }
    
    /*
     Mixture math behind the calculations:
     
     | lt  | xylocaine(%) | xylocaine(lt)
     -------------------------------------------------
     xylocaine w% | x   | w            | w * x
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
    func calculate(dextroseLiters: Double, mixPercentage: Double, xylocaineConcentration: Double) -> Double {
        // Set up variables
        let z = dextroseLiters
        let y = mixPercentage
        let w = xylocaineConcentration
        
        // Calculate x
        var x = ((z * y) / (w - y)) * 1000
        x = Double(round(100 * x) / 100)
        
        return x
    }
    
    func displayResults(xylocaineVolume: Double) {
        // Prepare calculated variables
        let xylocaineConcentration = "\(Double(self.xylocaineConcentration * 100))"
        let dextroseVolume = self.dextroseVolume.text!
        let mixtureConcentration = self.mixtrurePercentage.text!
        let mixtureVolume = "\(Double(self.dextroseVolume.text!)! + xylocaineVolume)"
        
        // Instructions
        self.instructions.isHidden = false
        self.instructions.text = "Add " +
            "\(xylocaineVolume)" +
            "ml of " +
            "\(xylocaineConcentration)" +
            "% lidocaine concentrate into " +
            "\(dextroseVolume)" +
            "ml of water for injection to get a lidocaine mixture of " +
            "\(mixtureConcentration)" +
            "% concentration and a total volume of " +
            "\(mixtureVolume)" +
        "ml"
    }
    
    func configure() {
        // UI set up
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
        self.mixtrurePercentage.delegate = self
        self.dextroseVolume.delegate = self
        
        // Show the num pad
        self.mixtrurePercentage.keyboardType = UIKeyboardType.numbersAndPunctuation
        self.dextroseVolume.keyboardType = UIKeyboardType.numbersAndPunctuation
        
        // Load default values based on the last used inputs
        self.initializeDefaults()
    }
    
    func clearResults() {
        self.xylocaineVolume.text = ""
        self.instructions.text = ""
        self.instructions.isHidden = true
    }
    
    /// Hide keyboard on tapping outside. Hide on pressing enter is handled from the teetc view delegate
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
