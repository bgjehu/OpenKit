//
//  String.swift
//  ExtensionKit
//
//  Created by Jieyi Hu on 9/12/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

public extension String {
    
    var objCString : NSString {
        get{
            return (self as NSString)
        }
    }
    
    var pathComponents: [String] {
        get{
            return self.objCString.pathComponents
        }
    }
    
    var lastPathComponent: String {
        get{
            return self.objCString.lastPathComponent
        }
    }
    var stringByDeletingLastPathComponent: String {
        get{
            return self.objCString.stringByDeletingLastPathComponent
        }
    }
    func stringByAppendingPathComponent(str: String) -> String {
        return self.objCString.stringByAppendingPathComponent(str)
    }
    
    var pathExtension: String {
        get{
            return self.objCString.pathExtension
        }
    }
    var stringByDeletingPathExtension: String {
        get{
            return self.objCString.stringByDeletingPathExtension
        }
    }
    func stringByAppendingPathExtension(str: String) -> String? {
        return self.objCString.stringByAppendingPathExtension(str)
    }
    
    func stringsByAppendingPaths(paths: [String]) -> [String] {
        return self.objCString.stringsByAppendingPaths(paths)
    }
    
    func getImageFromBase64String() -> UIImage? {
        return UIImage(data: NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
    }
}

