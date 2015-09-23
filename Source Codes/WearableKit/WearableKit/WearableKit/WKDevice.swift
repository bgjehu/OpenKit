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
    func isSensorAvailable(sensor : WKSensor) -> Bool
    func isSensorOn(sensor : WKSensor) -> Bool
    func startSensor(sensor : WKSensor)
    func stopSensor(sensor : WKSensor)
    func registerNotification(notificationType : WKNotificationType, sensor : WKSensor, observer:AnyObject, selector: Selector)
    func deregisterNotification(notificationType : WKNotificationType, sensor : WKSensor, observer:AnyObject)
    static func sharedDevice() -> WKDevice

}
