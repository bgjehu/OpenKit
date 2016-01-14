//
//  MSBApplicationInstallationSharedObject.swift
//  AirFlip
//
//  Created by Jieyi Hu on 9/24/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

import UIKit

public class MSBApplicationInstallationSharedObject: NSObject {
    var application : MSBApplication!
    var remainCapacity : UInt?
    var existingTiles : [MSBTile]?
    var oldTile : MSBTile?
    var infos = [String]()
    var errors = [NSError]()
    init(application : MSBApplication) {
        self.application = application
    }
}
