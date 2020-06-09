//
//  ViewController.swift
//  SpeedTracker
//
//  Created by Olena Rostovtseva on 25.05.2020.
//  Copyright © 2020 orost. All rights reserved.
//

import CoreLocation
import UIKit

class ViewController: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        startStopButton.layer.cornerRadius = 40

        locationManager.delegate = self
        resultTableView.dataSource = self

        setObservers()
        initUI()
    }

    fileprivate func initUI() {
        resultTableView.register(UINib(nibName: K.resultNibName, bundle: nil), forCellReuseIdentifier: K.reusableCellIdentifier)
    }

    fileprivate func setObservers() {
        speedManager.totalDriveTime.observe = { time in
            self.updateTime(time)
        }
        speedManager.speedResults.observe = { _ in
            print("Updating table")
            DispatchQueue.main.async {
                self.resultTableView.reloadData()
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
    }

    @IBAction func clearTime(_ sender: Any) {
        speedManager.clear()
        if isLocationUpdating {
            speedManager.start()
        }
    }

    @IBAction func startStopButton(_ sender: Any) {
        if !isLocationUpdating {
            locationManager.startUpdatingLocation()
            speedManager.start()
        } else {
            locationManager.stopUpdatingLocation()
            speedManager.stop()
        }
        isLocationUpdating = !isLocationUpdating
        updateUI()
    }

    fileprivate func updateUI() {
        if isLocationUpdating {
            startStopButton.setTitle(K.stopText, for: .normal)
        } else {
            startStopButton.setTitle(K.startText, for: .normal)
        }
    }

    fileprivate func updateTime(_ time: TimeInterval) {
        hourLabel.text = time.getHourText()
        minLabel.text = time.getMinText()
        secLabel.text = time.getSecText()
        milliSecLabel.text = time.getMilliSecText()
    }
}

// MARK: - CLLocationManagerDelegate section

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            DispatchQueue.main.async {
                var speed = location.speed
                if speed < 0.0 {
                    speed = 0.0
                }
                self.speedManager.updateCurrentSpeed(newSpeed: speed)
                let speedText = String(format: "%.1f", location.speed)
                // print(speedText)
                self.speedLabel.text = speedText
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCellIdentifier, for: indexPath) as! ResultCell
        if let result = speedManager.getSpeedResult(for: indexPath.row) {
            cell.speedResult.text = String(result.speed)
            cell.timeResult.text = String(result.time.getFullTimeText())
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        speedManager.getResultsCount()
    }
}
