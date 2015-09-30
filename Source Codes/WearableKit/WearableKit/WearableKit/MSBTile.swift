//
//  MSBTile.swift
//  AirFlip
//
//  Created by Jieyi Hu on 9/24/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

// MARK: MSBTile
public extension MSBTile {
    static func create(tileName : String, tileIconName : String, smallIconName : String, tileId : String) -> MSBTile? {
        let uuid = NSUUID(UUIDString: tileId)
        let tileIconImage = UIImage(named: tileIconName)
        let smallIconImage = UIImage(named: smallIconName)
        if uuid != nil && tileIconImage != nil && smallIconImage != nil {
            do{
                let tileIcon = try MSBIcon(UIImage: tileIconImage!)
                let smallIcon = try MSBIcon(UIImage: smallIconImage!)
                let tile = try MSBTile(id: uuid, name: tileName, tileIcon: tileIcon, smallIcon: smallIcon)
                return tile
            } catch let error as NSError {
                print(error)
                return nil
            }
        } else {
            return nil
        }
    }
    func addLayout(layout : MSBPageLayout) -> Bool {
        if self.pageLayouts.count < 8 {
            self.pageLayouts.addObject(layout)
            return true
        } else {
            return false
        }
    }
    
    func addLayouts(layouts : [MSBPageLayout]) -> Bool {
        if self.pageLayouts.count + layouts.count > 8 {
            return false
        } else {
            for layout in layouts {
                self.pageLayouts.addObject(layout)
            }
            return true
        }
    }
}

// MARK: [MSBTile]
public extension CollectionType where Generator.Element == MSBTile {
    func containsTile(tile : MSBTile) -> Bool {
        if self.count > 0 {
            for index in startIndex..<endIndex {
                if self[index].tileId == tile.tileId {
                    return true
                }
            }
            return false
        } else {
            return false
        }
    }
    func getTile(tileId : NSUUID) -> MSBTile? {
        if self.count > 0 {
            for index in startIndex..<endIndex {
                if self[index].tileId == tileId {
                    return self[index]
                }
            }
            return nil
        } else {
            return nil
        }
    }
}
