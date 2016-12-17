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
    @IBOutlet weak var xylocaineVolume: UILabel!
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var instructions: UITextView!
    @IBOutlet weak var xylocaineSelector: UISegmentedControl!
    
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
        let y = Double(self.mixturePercentage.text!)! / 100 // Convert to decimal
        let z = Double(self.dextroseVolume.text!)! / 1000.0 // Convert to liters
        let w = self.xylocaineConcentration
        
        // Calculate xylocaine volume
        if y < w { // Caution! the xylocaine concentration value will cause division by zero
            let x = get_x(dextroseLiters: z, mixPercentage: y, xylocaineConcentration: w)
            self.xylocaineVolume.text = "\(x) ml"
            self.displayResults(xylocaineVolume: x)
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
        var x = ((z * y) / (w - y)) * 1000
        x = Double(round(100 * x) / 100)
        
        return x
    }
    
    func displayResults(xylocaineVolume: Double) {
        let xylocaineConcentration = "\(Int(self.xylocaineConcentration * 100))"
        let dextroseVolume = self.dextroseVolume.text!
        let mixtureConcentration = self.mixturePercentage.text!
        let mixtureVolume = "\(Double(self.dextroseVolume.text!)! + xylocaineVolume)"
        
        self.resultTitle.text = "Lidocaine" + " \(xylocaineConcentration)" + "% volume:"
        
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
        self.mixturePercentage.delegate = self
        self.dextroseVolume.delegate = self
        
        // Show the num pad
        self.mixturePercentage.keyboardType = UIKeyboardType.numbersAndPunctuation
        self.dextroseVolume.keyboardType = UIKeyboardType.numbersAndPunctuation
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
    
    // Allow decimal numbers only
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldString = textField.text! as NSString
        let newString = textFieldString.replacingCharacters(in: range, with:string)
        let floatRegEx = "^([0-9]+)?(\\.([0-9]+)?)?$"
        let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
        return floatExPredicate.evaluate(with: newString)
    }
}

