//
//  MSBBandDelegate.swift
//  AirFlip
//
//  Created by Jieyi Hu on 9/24/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

import UIKit

@objc public protocol MSBBandDelegate {
    
    //  band successfully connected with info
    optional func band(band : MSBBand, didConnectWithInfo info: [NSObject : AnyObject]?)
    
    //  band failed to connect with error returned
    optional func band(band : MSBBand, failedConnectWithError error : NSError)
    
    //  band successfully disconnected with info
    optional func band(band : MSBBand, didDisconnectWithInfo info : [NSObject : AnyObject]?)
    
    //  band failed to disconnect with error
    optional func band(band : MSBBand, failedDisconnectWithError error : NSError)
    
    //  band successfully started sensor with info
    optional func band(band : MSBBand, didStartSensorWithType type : MSBSensorType, andInfo info : [NSObject : AnyObject]?)
    
    //  band failed to start sensor with error
    optional func band(band : MSBBand, failedStartSensorWithType type : MSBSensorType, andError error : NSError)
    
    //  band successfully stopped sensor with info
    optional func band(band : MSBBand, didStopSensorWithType type : MSBSensorType, andInfo userInfo : [NSObject : AnyObject]?)
    
    //  band failed to stop sensor with error
    optional func band(band : MSBBand, failedStopSensorWithType type : MSBSensorType, andError error : NSError)
    
    //  band retrieved sensor data
    optional func band(band : MSBBand, didRetrieveData data : AnyObject, withSensorType type : MSBSensorType)
    
    //  band successfully retrieve remain capacity
    optional func band(band : MSBBand, didRetrieveCapacity capacity : UInt)
    
    //  band failed to retrieve remain capacity with error
    optional func band(band : MSBBand, failedRetrieveCapacity capacity : UInt, withError error : NSError)
    
    //  band successfully retrieve tiles
    optional func band(band : MSBBand, didRetrieveTiles tiles : [MSBTile])
    
    //  band failed to retrieve tiles with error
    optional func band(band : MSBBand, failedRetrieveTiles tiles : [MSBTile], withError error : NSError)
    
    //  band successfully add tile
    optional func band(band : MSBBand, didAddTile tile : MSBTile)
    
    //  band failed to add tile with error
    optional func band(band : MSBBand, failedAddTile tile : MSBTile, withError error : NSError)
    
    //  band successfully set pages for tile
    optional func band(band : MSBBand, didSetPages pages : [MSBPageData], forTile tile : MSBTile)
    
    //  band failed to set pages for tile with error
    optional func band(band : MSBBand, failedSetPages pages : [MSBPageData], forTile tile : MSBTile, withError error : NSError)
    
    //  band successfully remove tile
    optional func band(band : MSBBand, didRemoveTile tile : MSBTile)
    
    //  band failed to remove tile with error
    optional func band(band : MSBBand, failedRemoveTile tile : MSBTile, withError error : NSError)
    
    //  band successfully install app
    optional func band(band : MSBBand, didInstalApplication application : MSBApplication)
    
    //  band failed to install app
    optional func band(band : MSBBand, failedInstalApplicationWithSharedObject object :  MSBApplicationInstallationSharedObject?)
    
    //  band successfully remove app
    optional func band(band : MSBBand, didRemoveApplication application : MSBApplication)
    
    //  band failed to remove app
    optional func band(band : MSBBand, failedRemoveApplication application : MSBApplication, withError error : NSError)
}
