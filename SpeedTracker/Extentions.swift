//
//  Extentions.swift
//  SpeedTracker
//
//  Created by Olena Rostovtseva on 26.05.2020.
//  Copyright © 2020 orost. All rights reserved.
//

import Foundation

extension TimeInterval {
    func getHourText() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: self)!
    }

    func getMinText() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: self)!
    }

    func getSecText() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: self)!
    }

    func getMilliSecText() -> String {
        let ms = Int(truncatingRemainder(dividingBy: 1) * 1000)
        var msText = "000"
        if ms > 0 {
            msText = String(ms)
        }
        return msText
    }

    func getFullTimeText() -> String {
        let ms = Int(truncatingRemainder(dividingBy: 1) * 1000)
        var msText = "000"
        if ms > 0 {
            msText = String(ms)
        }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: self)! + ":\(ms)"
    }
}
