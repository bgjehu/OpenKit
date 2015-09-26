//
//  MSBPageData.swift
//  AirFlip
//
//  Created by Jieyi Hu on 9/24/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

public extension MSBPageData {
    static func create(pageId : String, layoutIndex : UInt, value : [MSBPageElementData]) -> MSBPageData? {
        if let uuid = NSUUID(UUIDString: pageId) {
            let data = MSBPageData(id: uuid, layoutIndex: layoutIndex, value: value)
            return data
        } else {
            return nil
        }
    }
}
