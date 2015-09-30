//
//  MSBBandTileDelegate.swift
//  AirFlip
//
//  Created by Jieyi Hu on 9/26/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

import UIKit

@objc public protocol MSBBandTileDelegate {
    
    //  band open tile
    optional func band(band : MSBBand, didOpenTileWithEvent event : MSBTileEvent)
    
    //  band close tile
    optional func band(band : MSBBand, didCloseTileWithEvent event : MSBTileEvent)
    
    //  band button pressed
    optional func band(band : MSBBand, hadButtonPressedWithEvent event : MSBTileButtonEvent)
}
