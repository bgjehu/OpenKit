//
//  WKNotificationType.swift
//  WearableKit
//
//  Created by Jieyi Hu on 8/29/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit

@objc public enum WKNotificationType : Int {
    case didFinishConnecting = 0
    case failedFinishConnecting
    case didFinishDisconnecting
//  case failedFinishDisconnecting
    case didFinishStartingSensor
    case failedFinishStartingSensor
    case didFinishStoppingSensor
    case failedFinishStoppingSensor
}
