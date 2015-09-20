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
    
    public static var sharedDevice : WKDevice = WKMicrosoftBand()
    
    //  Connection
    private var _connected : Bool {
        get{
            if bandClient != nil {
                return bandClient.isDeviceConnected
            } else {
                return false
            }
        }
        set{
            if newValue == connected {
                //  no change
            } else {
                if newValue {
                    //  try to connect
                    if bandClient != nil {
                        MSBClientManager.sharedManager().connectClient(bandClient)
                        print("WKMicrosoftBand Log: Try to connected to Microsoft Band...")
                    } else {
                        //  Do nothing
                    }
                } else {
                    //  try to disconnect
                    if bandClient != nil {
                        MSBClientManager.sharedManager().cancelClientConnection(bandClient)
                        print("WKMicrosoftBand Log: Try to disconnected to Microsoft Band...")
                    } else {
                        //  Do nothing
                    }
                }
            }
        }
    }
    public var connected : Bool {
        get{
            return _connected
        }
    }
    public func connect() {
        _connected = true
    }
    public func disconnect() {
        _connected = false
    }
    
    private var _accelerometerOn : Bool = false{
        didSet{
            if oldValue == _accelerometerOn {
                //  no change
            } else {
                if _accelerometerOn {
                    //  try to turn on accelerometer
                    do{
                        try bandClient.sensorManager.startAccelerometerUpdatesToQueue(soloQueue, withHandler: { (data, error) -> Void in
                            if let data = data {
                                //  there is data
                                let dataf = [data.x,data.y,data.z]
                                self.accelerometerDataHandler?(dataf)
                            } else {
                                //  Do nothing
                            }
                        })
                        _accelerometerOn = true
                    } catch let error as NSError {print(error)}
                } else {
                    do{
                        try bandClient.sensorManager.stopAccelerometerUpdatesErrorRef()
                        _accelerometerOn = false
                    } catch let error as NSError {print(error)}
                }
            }
        }
    }
    public var accelerometerOn : Bool {
        get{
            return _accelerometerOn
        }
    }
    public func startAccelerometer() {
        _accelerometerOn = true
    }
    public func stopAccelerometer() {
        _accelerometerOn = false
    }
    
    public var accelerometerDataHandler : ([Double] -> ())?
    
    public func registerConnectedNotification(observer: AnyObject, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: WKNotifications.deviceDidConnect(self).name, object: nil)
    }
    
    public func deregisterConnectedNotification(observer: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(observer, name: WKNotifications.deviceDidConnect(self).name, object: nil)
    }

    public func registerDisconnectedNotification(observer: AnyObject, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: WKNotifications.deviceDidDisconnect(self).name, object: nil)
    }
    
    public func deregisterDisconnectedNotification(observer: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(observer, name: WKNotifications.deviceDidDisconnect(self).name, object: nil)
    }

    
    private override init() {
        super.init()
        let clients = MSBClientManager.sharedManager().attachedClients()
        if clients.count > 0 {
            bandClient = clients[0] as? MSBClient
            MSBClientManager.sharedManager().delegate = self
        } else {
            print("WKBand Error: Cannot create WKBand instance with no MSBand attached")
        }
    }
    

    
    private var bandClient : MSBClient!
    private var soloQueue : NSOperationQueue {
        get{
            let soloQueue = NSOperationQueue()
            soloQueue.maxConcurrentOperationCount = 1
            return soloQueue
        }
    }

    
    public func clientManager(clientManager: MSBClientManager!, client: MSBClient!, didFailToConnectWithError error: NSError!) {
        print(error)
    }
    public func clientManager(clientManager: MSBClientManager!, clientDidConnect client: MSBClient!) {
        NSNotificationCenter.defaultCenter().postNotification(WKNotifications.deviceDidConnect(self))
        print("WKMicrosoftBand Log: Microsoft Band is connected")
    }
    public func clientManager(clientManager: MSBClientManager!, clientDidDisconnect client: MSBClient!) {
        NSNotificationCenter.defaultCenter().postNotification(WKNotifications.deviceDidDisconnect(self))
        print("WKMicrosoftBand Log: Microsoft Band is disconnected")
    }
}
