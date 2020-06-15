//
//  SpeedExtensions.swift
//  SpeedTracker
//
//  Created by Olena Rostovtseva on 11.06.2020.
//  Copyright © 2020 orost. All rights reserved.
//

import CoreLocation
import Foundation

extension CLLocationSpeed {
    func speedToMPH() -> CLLocationSpeed {
        return self * 2.23694
    }

    func speedToKPH() -> CLLocationSpeed {
        return self * 3.6
    }
}
