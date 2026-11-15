//
//  UserDefaults.swift
//  mix
//
//  Created by Ioannis Tornazakis on 27/12/2016.
//  Copyright © 2016 polarbear.gr. All rights reserved.
//

import Foundation

extension ViewController {
    
    func initializeDefaults() {
        if UserDefaults.standard.object(forKey: self.lidocaineSelectorID) == nil {
            UserDefaults.standard.set(self.defaultLidocaineSelector, forKey: self.lidocaineSelectorID)
            UserDefaults.standard.set(self.defaultWaterVolume, forKey: self.waterVolumeID)
            UserDefaults.standard.set(self.defaultMixturePercentage, forKey: self.mixturePercentageID)
        } else {
            self.restoreLastUsedValues()
        }
    }
    
    func saveInput() {
        UserDefaults.standard.set(self.lidocaineSelector.selectedSegmentIndex, forKey: self.lidocaineSelectorID)
        UserDefaults.standard.set(self.waterVolume.text, forKey: self.waterVolumeID)
        UserDefaults.standard.set(self.mixtrurePercentage.text, forKey: self.mixturePercentageID)
    }
    
    func restoreLastUsedValues() {
        self.lidocaineSelector.selectedSegmentIndex = self.restoreLidocaineSelector()
        self.waterVolume.text = self.restoreWaterVolume()
        self.mixtrurePercentage.text = self.restoreMixturePercentage()
    }
    
    func restoreLidocaineSelector() -> Int {
        return UserDefaults.standard.integer(forKey: self.lidocaineSelectorID)
        
    }
    
    func restoreWaterVolume() -> String {
        return UserDefaults.standard.string(forKey: self.waterVolumeID)!
    }
    
    func restoreMixturePercentage() -> String{
        return UserDefaults.standard.string(forKey: self.mixturePercentageID)!
    }

}
