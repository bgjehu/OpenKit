//
//  SKInfo.swift
//  initialSlidesKit
//
//  Created by Jieyi Hu on 8/28/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit

public class SKInfo : NSObject {
    
    private var _dirPath : String!
    public var dirPath : String {
        get{
            return _dirPath
        }
    }
    
    private var _fileName : String!
    public var fileName : String {
        get{
            return _fileName
        }
    }
    
    public var filePath : String {
        get{
            return dirPath.stringByAppendingPathComponent(fileName)
        }
    }
    
    public var name : String {
        get{
            return fileName.stringByDeletingPathExtension
        }
    }
    
    public var ext : String {
        get{
            return fileName.pathExtension
        }
    }
    
    public var type : String {
        get{
            return ext.uppercaseString == "PDF" ? "PDF" : "PPT"
        }
    }
    
    public var creationData : String {
        return self.getFileDate(NSFileCreationDate)
    }
    
    public var modificationData : String {
        return self.getFileDate(NSFileModificationDate)
    }
    
    public var url : NSURL {
        get{
            return NSURL(fileURLWithPath: filePath)
        }
    }
    
    private var _numberOfPages : Int!
    public var numberOfPages : Int {
        get{
            return _numberOfPages
        }
    }
    
    private var _thumbnail : UIImage!
    public var thumbnail : UIImage {
        get{
            return _thumbnail
        }
    }

    internal init(dirPath : String, fileName : String) {
        super.init()
        self._dirPath = dirPath
        self._fileName = fileName
    }
    
    internal func setNumberOfPageAndThumbnail(numberOfPage : Int, thumbnail : UIImage) {
        _numberOfPages = numberOfPage
        _thumbnail = thumbnail
    }
    
    private func getFileDate(kindOfDate : String) -> String {
        let filePath = self.filePath
        do {
            //  get attributes of the file
            let attrs = try NSFileManager.defaultManager().attributesOfItemAtPath(filePath)
            //  get date string
            let dateString = attrs[kindOfDate]!.description
            //  return string
            return dateString.stringByReplacingOccurrencesOfString(" +0000", withString: "")
        } catch let error as NSError {
            print(error)
            return ""
        }
        
    }
}
