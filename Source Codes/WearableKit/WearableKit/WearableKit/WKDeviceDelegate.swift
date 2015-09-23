//
//  WKDeviceDelegate.swift
//  AirFlip
//
//  Created by Jieyi Hu on 9/22/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

import UIKit

@objc public protocol WKDeviceDelegate {
    optional func didFinishConnecting(device : WKDevice)
    optional func failedFinishConnecting(device : WKDevice, error : NSError)
    optional func didFinishDisconnecting(device : WKDevice)
//  optional func failedFinishDisconnecting(device : WKDevice, error : NSError)
    optional func didFinishStartingSensor(device : WKDevice, sensor : WKSensor)
    optional func failedFinishStartingSensor(device : WKDevice, sensor : WKSensor, error : NSError)
    optional func didFinishStoppingSensor(device : WKDevice, sensor : WKSensor)
    optional func failedFinishStoppingSensor(device : WKDevice, sensor : WKSensor, error : NSError)
    optional func hadSensorDataReady(device : WKDevice, sensor : WKSensor, data : AnyObject)
}
