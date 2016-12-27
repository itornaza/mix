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
        if UserDefaults.standard.object(forKey: self.xylocaineSelectorID) == nil {
            UserDefaults.standard.set(self.defaultXylocaineSelector, forKey: self.xylocaineSelectorID)
            UserDefaults.standard.set(self.defaultDextroseVolume, forKey: self.dextroseVolumeID)
            UserDefaults.standard.set(self.defaultMixturePercentage, forKey: self.mixturePercentageID)
        } else {
            self.restoreLastUsedValues()
        }
    }
    
    func saveInput() {
        UserDefaults.standard.set(self.xylocaineSelector.selectedSegmentIndex, forKey: self.xylocaineSelectorID)
        UserDefaults.standard.set(self.dextroseVolume.text, forKey: self.dextroseVolumeID)
        UserDefaults.standard.set(self.mixtrurePercentage.text, forKey: self.mixturePercentageID)
    }
    
    func restoreLastUsedValues() {
        self.xylocaineSelector.selectedSegmentIndex = self.restoreXylocaineSelector()
        self.dextroseVolume.text = self.restoreDextroseVolume()
        self.mixtrurePercentage.text = self.restoreMixturePercentage()
    }
    
    func restoreXylocaineSelector() -> Int {
        return UserDefaults.standard.integer(forKey: self.xylocaineSelectorID)
        
    }
    
    func restoreDextroseVolume() -> String {
        return UserDefaults.standard.string(forKey: self.dextroseVolumeID)!
    }
    
    func restoreMixturePercentage() -> String{
        return UserDefaults.standard.string(forKey: self.mixturePercentageID)!
    }

}
