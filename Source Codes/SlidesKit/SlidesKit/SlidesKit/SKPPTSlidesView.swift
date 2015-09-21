//
//  SKPPTSlidesView.swift
//  initialSlidesKit
//
//  Created by Jieyi Hu on 8/28/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit

internal class SKPPTSlidesView: UIWebView, UIWebViewDelegate, SKBaseSlidesView {

    private var filePath : String!
    private var _numberOfPages : Int = 0
    internal var numberOfPages : Int {
        get{
            return _numberOfPages
        }
    }
    private var _currentPage : Int = 0
    internal var currentPage : Int {
        get{
            return _currentPage
        }
    }
    private var thumbnail : UIImage!
    private var slidesDidLoad : (()->())?
    internal var view : UIView {
        get{
            return self as UIView
        }
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    internal func load(filePath: String, slidesDidLoad : (()->())?) {
        self.filePath = filePath
        self.delegate = self
        self.scalesPageToFit = true
        self.slidesDidLoad = slidesDidLoad
        self.loadRequest(filePath: filePath)
    }
    internal func webViewDidFinishLoad(webView: UIWebView) {
        self.removePageGap()
        _currentPage = 1
        _numberOfPages = webView.getNumberOfPages()
        thumbnail = webView.getScreenshot().resize(withNewSize: SKStandard.thumbnailSize)
        updateCache()
        slidesDidLoad?()
    }
    internal func gotoPage(pageNumber : Int){
        if pageNumber >= 1 && pageNumber <= numberOfPages {
            _currentPage = pageNumber
            self.scrollView.setContentOffset(CGPointMake(0, CGFloat(currentPage - 1) * self.frame.height) , animated: false)
        }
    }
    private func updateCache() {
        let fileName = filePath.lastPathComponent
        let dirPath = filePath.stringByDeletingLastPathComponent
        let cachePath = dirPath.stringByAppendingPathComponent("cache")
        var dirCache = [String : [String : AnyObject]]()
        if NSFileManager.defaultManager().fileExistsAtPath(cachePath) {
            //  load
            do{
                let jsonStr = try String(contentsOfFile: cachePath, encoding: NSUTF8StringEncoding)
                let jsonData = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
                let jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.AllowFragments)
                dirCache = jsonObject as! [String : [String : AnyObject]]
            } catch let error as NSError {
                print(error)
            }
            //  modify
            dirCache[fileName] = [String : AnyObject]()
            dirCache[fileName]!["numberOfPages"] = numberOfPages
            dirCache[fileName]!["thumbnail"] = thumbnail.base64Str
            //  store
            do{
                let jsonData = try NSJSONSerialization.dataWithJSONObject(dirCache, options: NSJSONWritingOptions.PrettyPrinted)
                let jsonStr = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
                try jsonStr?.writeToFile(cachePath, atomically: true, encoding: NSUTF8StringEncoding)
            } catch let error as NSError {
                print(error)
            }
        }
    }
}
