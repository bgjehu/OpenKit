//
//  MSBError.swift
//  AirFlip
//
//  Created by Jieyi Hu on 9/24/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

import UIKit

public class MSBError {
    private static var domain = "com.fullstackpug.MicrosoftBandKitExtension.MSBError"
    static var Unknown = NSError(domain: domain, code: -1, userInfo: ["Error" : "Unknown"])
    static var MSBBandIsNotAvailable = NSError(domain: domain, code: 0, userInfo: ["Error" : "MSBBand Is Not Available"])
    static var MSBBandIsNotConnected = NSError(domain: domain, code: 1, userInfo: ["Error" : "MSBBand Is Not Connected"])
    static var MSBApplicationInstallationSharedObjectIsNotInitializedCorrectly = NSError(domain: domain, code: 2, userInfo: ["Error" : "MSBApplicationInstallationSharedObject Is Not Initialized Correctly"])
    static var MSBBandCapacityIsFull = NSError(domain: domain, code: 3, userInfo: ["Error" : "MSBBand Capacity Is Full"])
    static var MSBBandFailedRetrieveCapacity = NSError(domain: domain, code: 4, userInfo: ["Error" : "MSBBand Failed To Retrieve Capacity"])
    static var MSBBandFailedRetrieveTiles = NSError(domain: domain, code: 5, userInfo: ["Error" : "MSBBand Failed To Retrieve Tiles"])
    
}