//
//  UserSettings.swift
//  SpeedTracker
//
//  Created by Olena Rostovtseva on 15.06.2020.
//  Copyright © 2020 orost. All rights reserved.
//

import Foundation

struct UserSettings {
    static let increaseSpeedRecordPrefsKey = "SpeedRecordIncrease"
    static let secondsToPreparePrefsKey = "SecondsToPrepare"
    
    func getRecordSpeedPrefValue() -> Double {
        return UserDefaults.standard.double(forKey: increaseSpeedRecordPrefsKey)
    }
    
    func getSecondsToPreparePrefValue() -> Int {
        return UserDefaults.standard.integer(forKey: secondsToPreparePrefsKey)
    }
    
    func setRecordSpeedPrefValue(speed: Double) {
        UserDefaults.standard.set(speed, forKey: increaseSpeedRecordPrefsKey)
    }
    
    func setSecondsToPreparePrefValue(seconds: Int) {
        UserDefaults.standard.set(seconds, forKey: secondsToPreparePrefsKey)
    }
}
