//
//  MSBNotificationType.swift
//  WearableKit
//
//  Created by Jieyi Hu on 8/29/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit

@objc public enum MSBNotificationType : Int {
    case didConnect = 0
    case failedConnect
    case didDisconnect
    case failedDisconnect
    case didStartSensor
    case failedStartSensor
    case didStopSensor
    case failedStopSensor
}
