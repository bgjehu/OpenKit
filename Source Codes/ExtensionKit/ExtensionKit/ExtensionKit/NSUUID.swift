//
//  NSUUID.swift
//  ExtensionKit
//
//  Created by Jieyi Hu on 9/24/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

import Foundation

public extension NSUUID {
    override func isEqual(object: AnyObject?) -> Bool {
        if let object = object {
            if object.isKindOfClass(NSUUID) {
                if let uuid = (object as? NSUUID)?.UUIDString {
                    return self.UUIDString == uuid
                }
            }
        }
        return super.isEqual(object)
    }
}
