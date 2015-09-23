//
//  WKSensor.swift
//  AirFlip
//
//  Created by Jieyi Hu on 9/22/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

import UIKit

@objc public enum WKSensor : Int {
    case None = 0
    case Accelerometer          //  1
    case Gyroscope              //  2
    case HeartRateSensor        //  3
    case SkinTemperatureSensor  //  4
    case Pedometer              //  5
    case UVSensor               //  6
    case CaloriesSensor         //  7
    case DistanceSensor         //  8
    case ContactSensor          //  9
}
