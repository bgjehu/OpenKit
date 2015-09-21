//
//  SKCacheManagerDelegate.swift
//  embeddedSK
//
//  Created by Jieyi Hu on 8/29/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

import UIKit

@objc public protocol SKCacheManagerDelegate {
    optional func retrievalDidFinish(cacheManager : SKCacheManager, cache : [SKInfo])
    optional func rebuildingDidFinish(cacheManager : SKCacheManager, cache : [SKInfo])
    optional func retrievalProgressReported(cacheManager : SKCacheManager, percent : Float)
    optional func rebuildingProgressReported(cacheManager : SKCacheManager, percent : Float)
}
