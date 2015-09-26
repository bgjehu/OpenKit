//
//  WKDeviceDelegate.swift
//  AirFlip
//
//  Created by Jieyi Hu on 9/22/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

import UIKit

@objc public protocol WKDeviceDelegate {
    
    //  device successfully connected with info
    optional func device(device : WKDevice, didConnectWithInfo info: [NSObject : AnyObject]?)
    
    //  device failed to connect with error returned
    optional func device(device : WKDevice, failedConnectWithError error : NSError)
    
    //  device successfully disconnected with info
    optional func device(device : WKDevice, didDisconnectWithInfo info : [NSObject : AnyObject]?)
    
    //  device failed to disconnect with error
    optional func device(device : WKDevice, failedDisconnectWithError error : NSError)
    
    //  device successfully started sensor with info
    optional func device(device : WKDevice, didStartSensorWithType type : WKSensorType, andInfo info : [NSObject : AnyObject]?)
    
    //  device failed to start sensor with error
    optional func device(device : WKDevice, failedStartSensorWithType type : WKSensorType, andError error : NSError)
    
    //  device successfully stopped sensor with info
    optional func device(device : WKDevice, didStopSensorWithType type : WKSensorType, andInfo userInfo : [NSObject : AnyObject]?)
    
    //  device failed to stop sensor with error
    optional func device(device : WKDevice, failedStopSensorWithType type : WKSensorType, andError error : NSError)
    
    //  device retrieved sensor data
    optional func device(device : WKDevice, didRetrieveData data : AnyObject, withSensorType type : WKSensorType)
}
