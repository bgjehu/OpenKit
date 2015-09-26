//
//  WKDevice.swift
//  WearableKit
//
//  Created by Jieyi Hu on 8/15/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit

@objc public protocol WKDevice : NSObjectProtocol {
    
    var name : String {get}
    var delegate : WKDeviceDelegate? {get set}
    var available : Bool {get}
    var connected : Bool {get}
    func connect()
    func disconnect()
    func isSensorAvailable(sensor : WKSensorType) -> Bool
    func isSensorOn(sensor : WKSensorType) -> Bool
    func startSensor(sensor : WKSensorType)
    func stopSensor(sensor : WKSensorType)
    func registerNotification(notificationType : WKNotificationType, sensor : WKSensorType, observer:AnyObject, selector: Selector)
    func deregisterNotification(notificationType : WKNotificationType, sensor : WKSensorType, observer:AnyObject)
    static func sharedDevice() -> WKDevice

}
