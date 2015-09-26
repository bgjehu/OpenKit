//
//  MSBClient.swift
//  AirFlip
//
//  Created by Jieyi Hu on 9/24/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

extension MSBClient {
    func install(app : MSBApplication) -> Bool {
        let remainSlotCount = getRemainSlotCount()
        let tiles = getTiles()
        let oldTile = tiles?.getTile(app.tile.tileId)
        if let oldTile = oldTile {
            //  old tile exists
            if removeTile(oldTile) {
                return addTile(app.tile, widhtPages: app.pages)
            } else {
                return false
            }
        } else {
            //  no old tile
            if remainSlotCount > 0 {
                return addTile(app.tile, widhtPages: app.pages)
            } else {
                //  no slot
                return false
            }
        }
    }
    
    func getRemainSlotCount() -> UInt? {
        var count : UInt?
        self.tileManager.remainingTileCapacityWithCompletionHandler { (remainSlotCount, error) -> Void in
            print(remainSlotCount)
            if error == nil {
                count = remainSlotCount
            } else {
                print(error)
                count = nil
            }
        }
        return count
    }
    
    func getTiles() -> [MSBTile]? {
        var tiles : [MSBTile]?
        self.tileManager.tilesWithCompletionHandler { (bandTiles, error) -> Void in
            if error == nil {
                tiles = bandTiles as? [MSBTile]
            } else {
                tiles = nil
            }
        }
        return tiles
    }
    
    func addTile(tile : MSBTile, widhtPages pages : [MSBPageData]) -> Bool {
        var result = false
        self.tileManager.addTile(tile, completionHandler: { (error) -> Void in
            if error == nil {
                result = self.setPagesForTile(tile, pages: pages)
            } else {
                print(error)
                result = false
            }
        })
        return result
    }
    
    func setPagesForTile(tile : MSBTile, pages : [MSBPageData]) -> Bool {
        var result = false
        self.tileManager.setPages(pages, tileId: tile.tileId, completionHandler: { (error) -> Void in
            if error == nil {
                result = true
            } else {
                print(error)
                result = false
            }
        })
        return result
    }
    
    func removeTile(tile : MSBTile) -> Bool {
        var result = false
        self.tileManager.removeTile(tile) { (error) -> Void in
            if error == nil {
                result = true
            } else {
                print(error)
                result = false
            }
        }
        return result
    }
    
    func removeTileWithId(tileId : NSUUID) -> Bool {
        var result = false
        self.tileManager.removeTileWithId(tileId) { (error) -> Void in
            if error == nil {
                result = true
            } else {
                print(error)
                result = false
            }
        }
        return result
    }
}

