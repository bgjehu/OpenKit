//
//  SKCache.swift
//  initialSlidesKit
//
//  Created by Jieyi Hu on 8/28/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit

internal class SKCache: NSObject {

    private var cachePath : String {
        get{
            return NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0].stringByAppendingPathComponent("slidesCache")
        }
    }
    private var cache = [String : [String : [String : AnyObject]]]()
    private override init(){
        super.init()
        load()
    }
    
    internal static var sharedCache : SKCache {
        get{
            return SKCache()
        }
    }
    
    private func load() {
        do{
            let jsonStr = try String(contentsOfFile: cachePath, encoding: NSUTF8StringEncoding)
            let jsonData = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.AllowFragments)
            cache = jsonObject as! [String : [String : [String : AnyObject]]]
        } catch let error as NSError {
            print(error)
        }
    }
    
    internal func store() {
        do{
            let jsonData = try NSJSONSerialization.dataWithJSONObject(cache, options: NSJSONWritingOptions.PrettyPrinted)
            let jsonStr = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
            try jsonStr?.writeToFile(cachePath, atomically: true, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            print(error)
        }
    }
    
    internal func cacheOut(dirPath : String, fileName : String) -> (numberOfPage : Int, thumbnail : UIImage)? {
        if let result = cache[dirPath] {
            if let result = result[fileName] {
                let numberOfPage = result["numberOfPages"] as! Int
                let thumbnail = ((result["thumbnail"] as! String).getImageFromBase64String())!
                return (numberOfPage, thumbnail)
            }
        }
        return nil
    }
    
    internal func cacheIn(info : SKInfo) {
        let dirPath = info.dirPath
        let fileName = info.fileName
        if cache[dirPath] == nil {
            cache[dirPath] = [String : [String : AnyObject]]()
        }
        cache[dirPath]![fileName] = [String : AnyObject]()
        cache[dirPath]![fileName]!["numberOfPages"] = info.numberOfPages
        cache[dirPath]![fileName]!["thumbnail"] = info.thumbnail.base64Str
    }
}
