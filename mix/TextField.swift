//
//  TextField.swift
//  mix
//
//  Created by Ioannis Tornazakis on 27/12/2016.
//  Copyright © 2016 polarbear.gr. All rights reserved.
//

import UIKit

extension ViewController: UITextFieldDelegate {
    
    /// Allow decimal numbers only up to 5 digits
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
    
    /// Hide keyboard on pressing enter from the textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
