//
//  Helpers.swift
//  mix
//
//  Created by Ioannis Tornazakis on 27/12/2016.
//  Copyright © 2016 polarbear.gr. All rights reserved.
//

import UIKit

extension ViewController {
    
    // Get lidocaine concentration from the segment control
    func getLidocaineConcentration(index: Int) {
        switch index {
        case ViewController.lidocaineSolution.onePerCent.rawValue:
            self.lidocaineConcentration = ViewController.lidocaineConcentrationValue.onePerCent.rawValue
            break
        default:
            self.lidocaineConcentration = ViewController.lidocaineConcentrationValue.twoPerCent.rawValue
            break
        }
    }
    
    // Check if there is an empty or zero
    func fieldsAreValid() -> Bool {
        if (self.waterVolume.text?.isEmpty)! || (self.mixtrurePercentage.text?.isEmpty)! {
            return false
        } else {
            return true
        }
    }
    
    func checkAndCalculate() {
        // Update the lidocaine percentage on the result title regardless of the checks
        self.resultTitle.text = "Lidocaine " + "\(Double(self.lidocaineConcentration * 100))" + "%"
        
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
    /// with greater concentrations than the starting lidocaine solution
    func calculationWrapper() {
        // Set up variables for calculations, validation is already done so safely unwrap text fields
        let y = Double(self.mixtrurePercentage.text!)! / 100 // Convert to decimal
        let z = Double(self.waterVolume.text!)! / 1000.0 // Convert to liters
        let w = self.lidocaineConcentration
        
        // Examine all possible values of input fields and calculate
        if Double(self.waterVolume.text!) == 0.0 && Double(self.mixtrurePercentage.text!) == 0.0 {
            // Both values are zero after a reset and off/on of the app
            self.clearResults()
        } else if Double(self.waterVolume.text!) == 0.0 {
            // Check if the water volume is zero
            self.instructions.text = "Hey, some water for injection to mix with?"
            self.instructions.isHidden = false
        } else if Double(self.mixtrurePercentage.text!) == 0.0 {
            // Check if the mixture percentage is zero
            self.instructions.text = "Well, it seems that you do not need a mix for that"
            self.instructions.isHidden = false
        } else if y < w { // Caution! the lidocaine concentration value will cause division by zero
            // Calculate lidocaine volume
            let x = self.calculate(waterLiters: z, mixPercentage: y, lidocaineConcentration: w)
            self.lidocaineVolume.text = "\(x) ml"
            self.displayResults(lidocaineVolume: x)
        } else {
            // The final mix cannot have greater lidocaine concentration!
            self.impossibleMix.text! = self.impossibleMixPrefix + "\(Double(self.lidocaineConcentration * 100))%"
            self.impossibleMix.isHidden = false
            self.clearResults()
        }
    }
    
    /*
     Mixture math behind the calculations:
     
                  | lt  | lidocaine(%) | lidocaine(lt)
     -------------------------------------------------
     lidocaine w% | x   | w            | w * x
     water        | z   | 0.0          | 0.0
     mix          | x+z | y            | (x+z) * y
     
     
     Solve for the third column,
     
          z(lt) * y(%)
     x =  ------------ * 1000(ml)
          w(%) - y(%)
     
     or,
     
                         water(lt) * mix(%)
     lidocaineVol(ml) =  --------------------- * 1000(ml)
                         lidocaine(%) - mix(%)
     
     */
    func calculate(waterLiters: Double, mixPercentage: Double, lidocaineConcentration: Double) -> Double {
        // Set up variables
        let z = waterLiters
        let y = mixPercentage
        let w = lidocaineConcentration
        
        // Calculate x
        var x = ((z * y) / (w - y)) * 1000
        x = Double(round(100 * x) / 100)
        
        return x
    }
    
    func displayResults(lidocaineVolume: Double) {
        // Prepare calculated variables
        let lidocaineConcentration = "\(Double(self.lidocaineConcentration * 100))"
        let waterVolume = self.waterVolume.text!
        let mixtureConcentration = self.mixtrurePercentage.text!
        let mixtureVolume = "\(Double(self.waterVolume.text!)! + lidocaineVolume)"
        
        // Instructions
        self.instructions.isHidden = false
        self.instructions.text = "Add " +
            "\(lidocaineVolume)" +
            "ml of " +
            "\(lidocaineConcentration)" +
            "% lidocaine concentrate into " +
            "\(waterVolume)" +
            "ml of water for injection to get a lidocaine mixture of " +
            "\(mixtureConcentration)" +
            "% concentration and a total volume of " +
            "\(mixtureVolume)" +
        "ml"
    }
    
    func configure() {
        // Initialize variables
        self.lidocaineConcentration = ViewController.lidocaineConcentrationValue.twoPerCent.rawValue
        
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
        self.waterVolume.delegate = self
        
        // Show the num pad
        self.mixtrurePercentage.keyboardType = UIKeyboardType.numbersAndPunctuation
        self.waterVolume.keyboardType = UIKeyboardType.numbersAndPunctuation
        
        // Load default values based on the last used inputs
        self.initializeDefaults()
        
        // Adjust for small iPhones
        self.configureSmallScreens()
    }
    
    /// Configure the UI element's appearance for the small iPhones
    func configureSmallScreens() {
        if UIScreen.main.nativeBounds.width == 640.0 {
            self.waterLabel.text = "Water"
            self.lidocaineConcentrationLabel.text = "Concentration"
            self.impossibleMixPrefix = "Cannot exceed "
        }
    }
    
    func clearResults() {
        self.lidocaineVolume.text = ""
        self.instructions.text = ""
        self.instructions.isHidden = true
    }
    
    /// Hide keyboard on tapping outside. Hide on pressing enter is handled from the teetc view delegate
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
