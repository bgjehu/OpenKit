//
//  WKMicrosoftBand.swift
//  WearableKit
//
//  Created by Jieyi Hu on 8/17/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit


public class WKMicrosoftBand: NSObject, WKDevice, MSBClientManagerDelegate {

    private let _name = "Microsoft Band"
    public var name : String {
        return _name
    }
    
    private var bandClient : MSBClient?
    
    private static var _sharedDevice : WKMicrosoftBand = WKMicrosoftBand()
    public static func sharedDevice() -> WKDevice {
        return _sharedDevice
    }
    
    public var delegate : WKDeviceDelegate?
    
    private var soloQueue : NSOperationQueue {
        get{
            let soloQueue = NSOperationQueue()
            soloQueue.maxConcurrentOperationCount = 1
            return soloQueue
        }
    }
    
    private let sensorIndexOffSet = 1
    
    private var _available : Bool = false
    public var available : Bool {
        get{
            return _available
        }
    }
    
    public var connected : Bool {
        get{
            if let bandClient = bandClient {
                return bandClient.isDeviceConnected
            } else {
                //  device is not even available
                return false
            }
        }
    }
    
    public func connect() {
        if available {
            if connected {
                //  already connected
            } else {
                MSBClientManager.sharedManager().connectClient(bandClient)
            }
        } else {
            //  device is not even availabel
        }
    }
    
    public func disconnect() {
        if available {
            if !connected {
                //  already disconnected
            } else {
                MSBClientManager.sharedManager().cancelClientConnection(bandClient)
            }
        } else {
            //  device is not even availabel
        }
    }
    
    private var sensorState : [Int : Bool] = [Int : Bool]()
    
    public func isSensorAvailable(sensor: WKSensor) -> Bool {
        if sensor.rawValue > 0 && sensor.rawValue <= 8 {
            return true
        } else {
            return false
        }
    }
    
    public func isSensorOn(sensor: WKSensor) -> Bool {
        if let on = sensorState[sensor.rawValue] {
            return on
        } else {
            return false
        }
    }

    
    public func startSensor(sensor: WKSensor) {
        if let on = sensorState[sensor.rawValue] {
            if on {
                //  sensor is on
            } else {
                do {
                    func handle(data : AnyObject?, error : NSError?) {
                        if error == nil {
                            self.sensorState[sensor.rawValue] = true
                        }
                        if let data = data {
                            self.delegate?.hadSensorDataReady!(self, sensor: sensor, data: data)
                        }
                    }
                    switch(sensor) {
                    case .Accelerometer:
                        try bandClient?.sensorManager.startAccelerometerUpdatesToQueue(soloQueue, withHandler: { (data, error) in
                            handle(data, error: error)
                        })
                    case .Gyroscope:
                        try bandClient?.sensorManager.startGyroscopeUpdatesToQueue(soloQueue, withHandler: { (data, error) in
                            handle(data, error: error)
                        })
                    case .HeartRateSensor:
                        try bandClient?.sensorManager.startHeartRateUpdatesToQueue(soloQueue, withHandler: { (data, error) in
                            handle(data, error: error)
                        })
                    case .SkinTemperatureSensor:
                        try bandClient?.sensorManager.startSkinTempUpdatesToQueue(soloQueue, withHandler: { (data, error) in
                            handle(data, error: error)
                        })
                    case .Pedometer:
                        try bandClient?.sensorManager.startPedometerUpdatesToQueue(soloQueue, withHandler: { (data, error) in
                            handle(data, error: error)
                        })
                    case .UVSensor:
                        try bandClient?.sensorManager.startUVUpdatesToQueue(soloQueue, withHandler: { (data, error) in
                            handle(data, error: error)
                        })
                    case .CaloriesSensor:
                        try bandClient?.sensorManager.startCaloriesUpdatesToQueue(soloQueue, withHandler: { (data, error) in
                            handle(data, error: error)
                        })
                    case .DistanceSensor:
                        try bandClient?.sensorManager.startDistanceUpdatesToQueue(soloQueue, withHandler: { (data, error) in
                            handle(data, error: error)
                        })
                    default:break
                    }
                    delegate?.didFinishStartingSensor!(self, sensor: sensor)
                    postNotification(.didFinishStartingSensor, sensor: sensor)
                } catch let error as NSError {
                    delegate?.failedFinishStartingSensor!(self, sensor: sensor, error: error)
                    postNotification(.failedFinishStartingSensor, sensor: sensor, userInfo: ["Error" : error])
                    print(error)
                }
            }
        } else {
            //  not a valid sensor for microsoft band
        }
    }
    public func stopSensor(sensor: WKSensor) {
        if let on = sensorState[sensor.rawValue] {
            if !on {
                //  sensor is off
            } else {
                do {
                    switch(sensor) {
                    case .Accelerometer:
                        try bandClient?.sensorManager.stopAccelerometerUpdatesErrorRef()
                    case .Gyroscope:
                        try bandClient?.sensorManager.stopGyroscopeUpdatesErrorRef()
                    case .HeartRateSensor:
                        try bandClient?.sensorManager.stopHeartRateUpdatesErrorRef()
                    case .SkinTemperatureSensor:
                        try bandClient?.sensorManager.stopSkinTempUpdatesErrorRef()
                    case .Pedometer:
                        try bandClient?.sensorManager.stopPedometerUpdatesErrorRef()
                    case .UVSensor:
                        try bandClient?.sensorManager.stopUVUpdatesErrorRef()
                    case .CaloriesSensor:
                        try bandClient?.sensorManager.stopCaloriesUpdatesErrorRef()
                    case .DistanceSensor:
                        try bandClient?.sensorManager.stopDistanceUpdatesErrorRef()
                    default:break
                    }
                    //  sensor stopped sucessfully
                    self.sensorState[sensor.rawValue] = false
                    delegate?.didFinishStoppingSensor!(self, sensor: sensor)
                    postNotification(.didFinishStoppingSensor, sensor: sensor)
                } catch let error as NSError {
                    delegate?.failedFinishStoppingSensor!(self, sensor: sensor, error: error)
                    postNotification(.failedFinishStoppingSensor, sensor: sensor, userInfo: ["Error" : error])
                    print(error)
                }
            }
        } else {
            //  not a valid sensor for microsoft band
        }
    }
    
    private override init() {
        super.init()
        let clients = MSBClientManager.sharedManager().attachedClients()
        if clients.count > 0 {
            _available = true
            bandClient = clients[0] as? MSBClient
            MSBClientManager.sharedManager().delegate = self
        } else {
            _available = false
        }
    }
    
    private func notification(notificationType : WKNotificationType, sensor : WKSensor) -> NSNotification {
        return NSNotification(name: "WKNOTIFICATION_\(name)_\(notificationType.rawValue)_\(sensor.rawValue)", object: nil)
    }
    private func notification(notificationType : WKNotificationType, sensor : WKSensor, userInfo : [NSObject : AnyObject]?) -> NSNotification {
        return NSNotification(name: "WKNOTIFICATION_\(name)_\(notificationType.rawValue)_\(sensor.rawValue)", object: nil, userInfo: userInfo)
    }
    
    private func postNotification(notificationType : WKNotificationType, sensor : WKSensor) {
        NSNotificationCenter.defaultCenter().postNotification(notification(notificationType, sensor: sensor))
    }
    
    private func postNotification(notificationType : WKNotificationType, sensor : WKSensor, userInfo : [NSObject : AnyObject]?) {
        NSNotificationCenter.defaultCenter().postNotification(notification(notificationType, sensor: sensor, userInfo: userInfo))
    }
    
    public func registerNotification(notificationType: WKNotificationType, sensor: WKSensor, observer: AnyObject, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: notification(notificationType, sensor: sensor).name, object: nil)
    }
    
    public func deregisterNotification(notificationType: WKNotificationType, sensor: WKSensor, observer: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(observer, name: notification(notificationType, sensor: sensor).name, object: nil)
    }

    
    
    public func clientManager(clientManager: MSBClientManager!, client: MSBClient!, didFailToConnectWithError error: NSError!) {
        delegate?.failedFinishConnecting!(self, error: error)
        postNotification(.failedFinishConnecting, sensor: .None, userInfo: ["Error" : error])
        print(error)
    }
    public func clientManager(clientManager: MSBClientManager!, clientDidConnect client: MSBClient!) {
        delegate?.didFinishConnecting!(self)
        postNotification(.didFinishConnecting, sensor: .None)
        print("WKMicrosoftBand Log: Microsoft Band is connected")
    }
    public func clientManager(clientManager: MSBClientManager!, clientDidDisconnect client: MSBClient!) {
        delegate?.didFinishDisconnecting!(self)
        postNotification(.didFinishDisconnecting, sensor: .None)
        print("WKMicrosoftBand Log: Microsoft Band is disconnected")
    }
}
