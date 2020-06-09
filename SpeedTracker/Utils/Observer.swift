//
//  Observer.swift
//  SpeedTracker
//
//  Created by Olena Rostovtseva on 02.06.2020.
//  Copyright © 2020 orost. All rights reserved.
//

import Foundation

class Observable<T: Equatable> {
    private let thread: DispatchQueue
    var property: T? {
        willSet(newValue) {
            if let newValue = newValue, property != newValue {
                thread.async {
                    self.observe?(newValue)
                }
            }
        }
    }

    var observe: ((T) -> ())?
    init(_ value: T? = nil, thread dispatcherThread: DispatchQueue = DispatchQueue.main) {
        self.thread = dispatcherThread
        self.property = value
    }
}
