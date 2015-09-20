//
//  WKNotifications.swift
//  WearableKit
//
//  Created by Jieyi Hu on 8/29/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit

class WKNotifications: NSObject {
    static func deviceDidConnect(device : WKDevice) -> NSNotification {
        return NSNotification(name: "WKNOTIFICATION_\(device.name)_DID_CONNECT", object: nil)
    }
    static func deviceDidDisconnect(device : WKDevice) -> NSNotification {
        return NSNotification(name: "WKNOTIFICATION_\(device.name)_DID_DISCONNECT", object: nil)
    }
}
