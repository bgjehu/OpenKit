//
//  MSBPageTextBlock.swift
//  AirFlip
//
//  Created by Jieyi Hu on 9/24/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

public extension MSBPageTextBlock {
    static func create(x : UInt16?, y : UInt16?, width : UInt16?, height : UInt16?, font : MSBPageTextBlockFont?, elementId : UInt16, baseline : UInt16?, baselineAlignment : MSBPageTextBlockBaselineAlignment?, horizontalAlignment : MSBPageHorizontalAlignment?, verticalAlignment : MSBPageVerticalAlignment?, autoWidth : Bool?, textColor : UIColor, topMargin : Int16?, bottomMargin : Int16?, leftMargin : Int16?, rightMargin : Int16?, visible : Bool?) -> MSBPageTextBlock? {
        do{
            let x = x == nil ? 0 : x!
            let y = y == nil ? 0 : y!
            let width = width == nil ? 200 : width!
            let height = height == nil ? 40 : height!
            let topMargin = topMargin == nil ? 2 : topMargin
            let bottomMargin = bottomMargin == nil ? 2 : bottomMargin
            let leftMargin = leftMargin == nil ? 5 : leftMargin
            let rightMargin = rightMargin == nil ? 5 : rightMargin
            let margins = MSBPageMargins(left: leftMargin!, top: topMargin!, right: rightMargin!, bottom: bottomMargin!)
            let textBlock = MSBPageTextBlock(rect: MSBPageRect(x: x, y: y, width: width, height: height), font: font == nil ? MSBPageTextBlockFont.Small : font!)
            textBlock.elementId = elementId
            textBlock.baseline = baseline == nil ? 25 : baseline!
            textBlock.baselineAlignment = baselineAlignment == nil ? MSBPageTextBlockBaselineAlignment.Relative : baselineAlignment!
            textBlock.horizontalAlignment = horizontalAlignment == nil ? MSBPageHorizontalAlignment.Center : horizontalAlignment!
            textBlock.verticalAlignment = verticalAlignment == nil ? MSBPageVerticalAlignment.Center : verticalAlignment!
            textBlock.autoWidth = autoWidth == nil ? false : autoWidth!
            textBlock.color = try MSBColor.colorWithUIColor(textColor) as? MSBColor
            textBlock.margins = margins
            textBlock.visible = visible == nil ? true : visible!
            return textBlock
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
}
