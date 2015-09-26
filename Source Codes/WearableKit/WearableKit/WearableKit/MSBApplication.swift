//
//  MSBApplication.swift
//  AirFlip
//
//  Created by Jieyi Hu on 9/24/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

// MARK: MSBApp
@objc public protocol MSBApplication {
    var id : NSUUID {get}
    var tile : MSBTile {get}
    var layouts : [MSBPageLayout] {get}
    var pages : [MSBPageData] {get}
}
