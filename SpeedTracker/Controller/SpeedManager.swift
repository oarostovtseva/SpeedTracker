//
//  SpeedManager.swift
//  SpeedTracker
//
//  Created by Olena Rostovtseva on 02.06.2020.
//  Copyright © 2020 orost. All rights reserved.
//

import CoreLocation
import Foundation

class SpeedManager {
    var totalDriveTime = Observable<TimeInterval>()
    var speedResults = Observable<[SpeedResult]>()
    
    private var currentSpeed: CLLocationSpeed = 0.0
    private var startDriveTime: TimeInterval = 0.0
    private var prevSpeedRecord: CLLocationSpeed = 0.0
    
    private var isZeroSpeed = false
    
    private var timer = Timer()
    
    func start() {
        startDriveTime = NSDate().timeIntervalSince1970
        timer = Timer.scheduledTimer(withTimeInterval: K.tenMs, repeats: true) { _ in
            if self.totalDriveTime.property != nil {
                self.totalDriveTime.property! += K.tenMs
                // print(self.totalDriveTime.property!)
            } else {
                self.totalDriveTime.property = 0.0
            }
        }
    }
    
    func stop() {
        timer.invalidate()
    }
    
    func clear() {
        timer.invalidate()
        totalDriveTime.property = 0.0
        prevSpeedRecord = 0.0
        startDriveTime = 0.0
        // isZeroSpeed = true
    }
    
    func updateCurrentSpeed(_ speed: CLLocationSpeed) {
        // We skip the first speed that we get and compare others to this one
        /* if isZeroSpeed {
             isZeroSpeed = false
             prevSpeedRecord = speed
             return
         } */
        if (speed - prevSpeedRecord) >= K.speedRecord, !isZeroSpeed {
            print("Yay, we got a record! speed:\(speed), prevSpeed:\(prevSpeedRecord)")
            addSpeedResult(speedResult: speed)
            prevSpeedRecord = speed
        }
        currentSpeed = speed
    }
    
    func getResultsCount() -> Int {
        if let results = speedResults.property {
            return results.count
        } else {
            return 0
        }
    }
    
    func getSpeedResult(for index: Int) -> SpeedResult? {
        if let results = speedResults.property {
            return results[index]
        } else {
            return nil
        }
    }
    
    fileprivate func addSpeedResult(speedResult: CLLocationSpeed) {
        let newResult = SpeedResult(speed: speedResult, time: calculateTimeInterval())
        if speedResults.property != nil {
            speedResults.property?.append(newResult)
        } else {
            speedResults.property = [newResult]
        }
    }
    
    fileprivate func calculateTimeInterval() -> TimeInterval {
        let nowTimeInterval = NSDate().timeIntervalSince1970
        let diff = nowTimeInterval - startDriveTime
        return diff
    }

}

struct SpeedResult: Equatable {
    let speed: CLLocationSpeed
    let time: TimeInterval
}
