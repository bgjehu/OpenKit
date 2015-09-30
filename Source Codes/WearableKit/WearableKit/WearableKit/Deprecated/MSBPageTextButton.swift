//
//  MSBPageTextButton.swift
//  AirFlip
//
//  Created by Jieyi Hu on 9/24/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

public extension MSBPageTextButton {
    static func create(x : UInt16?, y : UInt16?, width : UInt16?, height : UInt16?, elementId : UInt16, horizontalAlignment : MSBPageHorizontalAlignment?, verticalAlignment : MSBPageVerticalAlignment?, topMargin : Int16?, bottomMargin : Int16?, leftMargin : Int16?, rightMargin : Int16?, visible : Bool?) -> MSBPageTextButton {
        let x = x == nil ? 0 : x!
        let y = y == nil ? 0 : y!
        let width = width == nil ? 200 : width!
        let height = height == nil ? 40 : height!
        let topMargin = topMargin == nil ? 2 : topMargin
        let bottomMargin = bottomMargin == nil ? 2 : bottomMargin
        let leftMargin = leftMargin == nil ? 5 : leftMargin
        let rightMargin = rightMargin == nil ? 5 : rightMargin
        let margins = MSBPageMargins(left: leftMargin!, top: topMargin!, right: rightMargin!, bottom: bottomMargin!)
        let textBlock = MSBPageTextButton(rect: MSBPageRect(x: x, y: y, width: width, height: height))
        textBlock.elementId = elementId
        textBlock.horizontalAlignment = horizontalAlignment == nil ? MSBPageHorizontalAlignment.Center : horizontalAlignment!
        textBlock.verticalAlignment = verticalAlignment == nil ? MSBPageVerticalAlignment.Center : verticalAlignment!
        textBlock.margins = margins
        textBlock.visible = visible == nil ? true : visible!
        return textBlock
    }
}
