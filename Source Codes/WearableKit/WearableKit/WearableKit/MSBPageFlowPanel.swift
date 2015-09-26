//
//  MSBPageFlowPanel.swift
//  AirFlip
//
//  Created by Jieyi Hu on 9/24/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

public extension MSBPageFlowPanel {
    static func create(x : UInt16?, y : UInt16?, width : UInt16?, height : UInt16?, orientation : MSBPageFlowPanelOrientation?, elements : [MSBPageElement]?) -> MSBPageFlowPanel{
        let x = x == nil ? 0 : x!
        let y = y == nil ? 0 : y!
        let width = width == nil ? 200 : width!
        let height = height == nil ? 40 : height!
        let orientation = orientation == nil ? MSBPageFlowPanelOrientation.Horizontal : orientation!
        let flowPanel = MSBPageFlowPanel(rect: MSBPageRect(x: x, y: y, width: width, height: height))
        flowPanel.orientation = orientation
        if let elements = elements {
            flowPanel.addElements(elements)
        } else {
            //  do nothing
        }
        return flowPanel
    }
}
