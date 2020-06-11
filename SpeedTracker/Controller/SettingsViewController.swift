//
//  SettingsViewController.swift
//  SpeedTracker
//
//  Created by Olena Rostovtseva on 10.06.2020.
//  Copyright © 2020 orost. All rights reserved.
//

import CoreLocation
import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var recordStep: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        recordStep.text = String(K.speedRecord)
    }

    @IBAction func recordStepDidChange(_ sender: UITextView) {
        if let text = recordStep.text {
            if !text.isEmpty {
                K.speedRecord = CLLocationSpeed(text)!
            } else {
                recordStep.text = String(K.speedRecord)
            }
        } else {
            recordStep.text = String(K.speedRecord)
        }
    }
}
