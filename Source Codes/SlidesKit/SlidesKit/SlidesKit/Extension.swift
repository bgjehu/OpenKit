//
//  Extension.swift
//  initialSlidesKit
//
//  Created by Jieyi Hu on 8/26/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit

internal extension String {
    
    func fileExistWithTypes(types : [String]) -> Int {
        var isDir = ObjCBool(false)
        if NSFileManager.defaultManager().fileExistsAtPath(self, isDirectory: &isDir) {
            //  file exist
            if isDir.boolValue {
                //  is directory
                return 0
            } else {
                //  file exist and it is not a directory
                let ext = self.pathExtension
                if types.map({type in type.uppercaseString}).contains(ext.uppercaseString) {
                    //  has valid type
                    return 1
                } else {
                    //  file exist but wrong type
                    return -2
                }
            }
        } else {
            //  file does not exist
            return -1
        }
    }
    
    func slidesExist() -> Bool {
        return self.fileExistWithTypes(["PDF","PPT","PPTX"]) == 1 ? true : false
    }
    
    func hasSlidesExtension() -> Bool {
        let upper = self.uppercaseString
        return (upper.hasSuffix("PPT")||upper.hasSuffix("PPTX")||upper.hasSuffix("PDF"))
    }
    
    func dirExist() -> Bool {
        var isDir = ObjCBool(false)
        if NSFileManager.defaultManager().fileExistsAtPath(self, isDirectory: &isDir) {
            if isDir {
                //  dirPath exists, and it is directory
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
}


internal extension UIWebView {
    
    func getNumberOfPages() -> Int {
        let slideClassString = "<div class=\"slide\""
        let html = self.stringByEvaluatingJavaScriptFromString("document.body.innerHTML")
        let count = (html?.componentsSeparatedByString(slideClassString).count)! - 1
        return count
    }
    
    func removePageGap() {
        self.stringByEvaluatingJavaScriptFromString("var slides = document.getElementsByClassName('slide');var count = slides.length;for (var i = 1; i < count; i++) {var oldTop = slides[i].style.top;var newTop = parseInt(oldTop) - 5 * i + 'px';slides[i].style.top = newTop;}")
    }
}

