//
//  UIImage.swift
//  ExtensionKit
//
//  Created by Jieyi Hu on 9/12/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

public extension UIImage {
    
    var base64Str : String? {
        get{
            return UIImagePNGRepresentation(self)?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        }
    }
    
    func resize(withNewSize newSize : CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize,false,0.0)
        self.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
