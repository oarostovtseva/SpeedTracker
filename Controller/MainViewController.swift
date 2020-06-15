//
//  ViewController.swift
//  SpeedTracker
//
//  Created by Olena Rostovtseva on 25.05.2020.
//  Copyright © 2020 orost. All rights reserved.
//

import CoreLocation
import UIKit

class MainViewController: UIViewController {
    @IBOutlet var startStopButton: UIButton!
    @IBOutlet var speedLabel: UILabel!

    @IBOutlet var hourLabel: UILabel!
    @IBOutlet var minLabel: UILabel!
    @IBOutlet var secLabel: UILabel!
    @IBOutlet var milliSecLabel: UILabel!

    @IBOutlet var resultTableView: UITableView!

    let locationManager = CLLocationManager()
    var isLocationUpdating = false

    let speedManager = SpeedManager()
    private var goTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        startStopButton.layer.cornerRadius = startStopButton.frame.size.width / 2

        locationManager.delegate = self
        resultTableView.dataSource = self

        setObservers()
        initUI()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
    }

    @IBAction func clear(_ sender: Any) {
        speedManager.clear()
        if isLocationUpdating {
            speedManager.start()
        } else {
            updateSpeedUI(CLLocationSpeed(0.0))
        }
    }

    @IBAction func startStopButton(_ sender: Any) {
        if !isLocationUpdating {
            startRecording()
        } else {
            stopRecording()
        }
    }

    fileprivate func initUI() {
        resultTableView.register(UINib(nibName: K.resultNibName, bundle: nil), forCellReuseIdentifier: K.reusableCellIdentifier)
    }

    fileprivate func setObservers() {
        speedManager.totalDriveTime.observe = { time in
            self.updateTimeUI(time)
        }
        speedManager.speedResults.observe = { _ in
            print("Updating table")
            DispatchQueue.main.async {
                self.resultTableView.reloadData()
            }
        }
    }

    fileprivate func startRecording() {
        startStopButton.isEnabled = false
        var prepareSeconds = K.prepareSeconds
        goTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if prepareSeconds > 0 {
                self.startStopButton.setTitle(String(prepareSeconds), for: .normal)
            } else if prepareSeconds == 0 {
                self.startStopButton.setTitle("Go!", for: .normal)
            } else {
                self.locationManager.startUpdatingLocation()
                self.speedManager.start()
                self.goTimer.invalidate()
                self.startStopButton.isEnabled = true
                self.isLocationUpdating = !self.isLocationUpdating
                self.updateStartStopButton()
            }
            prepareSeconds -= 1
        }
    }

    fileprivate func stopRecording() {
        locationManager.stopUpdatingLocation()
        speedManager.stop()
        isLocationUpdating = !isLocationUpdating
        updateStartStopButton()
    }

    fileprivate func updateStartStopButton() {
        if isLocationUpdating {
            startStopButton.setTitle(K.stopText, for: .normal)
        } else {
            startStopButton.setTitle(K.startText, for: .normal)
        }
    }

    fileprivate func updateTimeUI(_ time: TimeInterval) {
        hourLabel.text = time.getHourText()
        minLabel.text = time.getMinText()
        secLabel.text = time.getSecText()
        milliSecLabel.text = time.getMilliSecText()
    }

    fileprivate func updateSpeedUI(_ speed: CLLocationSpeed) {
        let speedText = String(format: "%.1f", speed)
        self.speedLabel.text = speedText
    }
}

// MARK: - CLLocationManagerDelegate section

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            DispatchQueue.main.async {
                var speed = location.speed
                if speed < 0.0 {
                    speed = 0.0
                }
                self.speedManager.updateCurrentSpeed(speed.speedToKPH())
                self.updateSpeedUI(speed.speedToKPH())
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCellIdentifier, for: indexPath) as! ResultCell
        if let result = speedManager.getSpeedResult(for: indexPath.row) {
            cell.speedResult.text = String(format: "%.3f", result.speed)
            cell.timeResult.text = String(result.time.getFullTimeText())
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        speedManager.getResultsCount()
    }
}
