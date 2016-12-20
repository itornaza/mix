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
    
    //------------
    // Helpers
    //------------
    
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
    
    func calculationWrapper() {
        // Set up variables for calculations, validation is already done so safely unwrap text fields
        let y = Double(self.mixtrurePercentage.text!)! / 100 // Convert to decimal
        let z = Double(self.dextroseVolume.text!)! / 1000.0 // Convert to liters
        let w = self.xylocaineConcentration
        
        // Examine all passible values of input fields and calculate
        if Double(self.dextroseVolume.text!) == 0.0 {
            // Check if the dextrose volume is zero
            self.instructions.text = "Hey, some water for injection to mix with?"
            self.instructions.isHidden = false
        } else if
            // Check if the mixture percentage is zero
            Double(self.mixtrurePercentage.text!) == 0.0 {
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
        self.mixtrurePercentage.delegate = self
        self.dextroseVolume.delegate = self
        
        // Show the num pad
        self.mixtrurePercentage.keyboardType = UIKeyboardType.numbersAndPunctuation
        self.dextroseVolume.keyboardType = UIKeyboardType.numbersAndPunctuation
    }
    
    func clearResults() {
        self.xylocaineVolume.text = ""
        self.instructions.text = ""
        self.instructions.isHidden = true
    }
    
    // Hide keyboard on tapping outside
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //----------------------
    // TextFieldDelegate
    //----------------------
    
    // Allow decimal numbers only up to 5 digits
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Test for decimal format
        let textFieldString = textField.text! as NSString
        let newString = textFieldString.replacingCharacters(in: range, with:string)
        let floatRegEx = "^([0-9]+)?(\\.([0-9]+)?)?$"
        let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
        let isDecimal: Bool = floatExPredicate.evaluate(with: newString)
        
        // Test for proper lenght
        let maxNumberOfDigits = 5
        let hasLenght: Bool = newString.characters.count <= maxNumberOfDigits
        
        // If both conditions hold return true
        return isDecimal && hasLenght
    }
    
    // Hide keyboard on pressing enter from the textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
