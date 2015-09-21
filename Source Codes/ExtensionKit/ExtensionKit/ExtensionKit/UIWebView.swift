//
//  UIWebView.swift
//  ExtensionKit
//
//  Created by Jieyi Hu on 9/12/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

public extension UIWebView {
    
    func loadRequest(filePath filePath : String) {
        let url = NSURL(fileURLWithPath: filePath)
        let request = NSURLRequest(URL: url)
        self.loadRequest(request)
    }
    
    func getScreenshot() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}