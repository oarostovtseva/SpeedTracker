//
//  SettingsViewController.swift
//  SpeedTracker
//
//  Created by Olena Rostovtseva on 10.06.2020.
//  Copyright © 2020 orost. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var secondsToPrepare: UITextField!
    @IBOutlet var recordStep: UITextField!
    
    let userSettings = UserSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordStep.text = String(userSettings.getRecordSpeedPrefValue())
        secondsToPrepare.text = String(userSettings.getSecondsToPreparePrefValue())
    }

    @IBAction func recordStepDidChange(_ sender: UITextView) {
        if let text = recordStep.text {
            if !text.isEmpty {
                userSettings.setRecordSpeedPrefValue(speed: Double(text)!)
            }
        }
    }
    @IBAction func secondsToPrepareDidChange(_ sender: UITextView) {
        if let text = recordStep.text {
            if !text.isEmpty {
                userSettings.setSecondsToPreparePrefValue(seconds: Int(text)!)
            }
        }
    }

}
