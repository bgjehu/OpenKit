//
//  WKDevice.swift
//  WearableKit
//
//  Created by Jieyi Hu on 8/15/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit

public protocol WKDevice : NSObjectProtocol {
    var name : String {get}
    
    static var sharedDevice : WKDevice {get}
    
    var connected : Bool {get}
    func connect()
    func disconnect()
    
    var accelerometerOn : Bool {get}
    func startAccelerometer()
    func stopAccelerometer()
    
    var accelerometerDataHandler : ([Double] -> ())? {get set}
    
    func registerConnectedNotification(observer:AnyObject, selector: Selector)
    func deregisterConnectedNotification(observer:AnyObject)
    func registerDisconnectedNotification(observer:AnyObject, selector: Selector)
    func deregisterDisconnectedNotification(observer:AnyObject)

}
