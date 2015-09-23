//
//  SKCacheManager.swift
//  initialSlidesKit
//
//  Created by Jieyi Hu on 8/28/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit

public enum SKCacheManagerAction : String{
    case retrieve = "retrieve"
    case rebuild = "rebuild"
    case none = "none"
}

public class SKCacheManager: NSObject, UIWebViewDelegate {

    private var _dirPath : String = ""
    public var dirPath: String {
        get{
            return _dirPath
        }
    }
    private var sharedCache = SKCache.sharedCache
    private var waitlist : [SKInfo]!
    private var resultList : [SKInfo]!
    private var totalWorkLoad : Int = 0
    private var firstOnList : SKInfo {
        get{
            return waitlist[0]
        }
    }
    
    private var webView : UIWebView!
    private var newWebView : UIWebView {
        get{
            webView = UIWebView(frame: SKStandard.thumbnailFrame)
            webView.scalesPageToFit = true
            webView.delegate = self
            return webView
        }
    }
    private var ongoingAction : SKCacheManagerAction = .retrieve
    public var delegate : SKCacheManagerDelegate?
    
    public override init(){
        super.init()
    }
    
    private func reset() {
        waitlist = [SKInfo]()
        resultList = [SKInfo]()
        totalWorkLoad = 0
    }
    
    public func webViewDidFinishLoad(webView: UIWebView) {
        //  set cache info
        firstOnList.setNumberOfPageAndThumbnail(webView.getNumberOfPages(), thumbnail: webView.getScreenshot())
        moveToResultList()
    }
    
    public func action(action : SKCacheManagerAction, dirPath : String) {
        switch(action){
        case .none:
            break;
        default:
            self.ongoingAction = action
            reset()
            if dirPath.dirExist() {
                _dirPath = dirPath
                totalWorkLoad = scanDir(scanAll: action == .rebuild)
                runList()
            } else {
                print("SKCache Error: \(action.rawValue) cache with invalid dirPath = \(dirPath)")
            }
        }
    }
    public func rebuild(dirPath : String) {
        action(.rebuild, dirPath: dirPath)
    }
    public func retrieve(dirPath : String) {
        action(.retrieve, dirPath: dirPath)
    }
    

    
    private func scanDir(scanAll scanAllOptionOn : Bool) -> Int {
        //  iterate thru dirPath
        let dirPathEnum = NSFileManager.defaultManager().enumeratorAtPath(dirPath)
        while let element = dirPathEnum?.nextObject() as? String {
            if element.hasSlidesExtension() {
                if !scanAllOptionOn {
                    if let fileCache = sharedCache.cacheOut(dirPath, fileName: element) {
                        let info = SKInfo(dirPath: dirPath, fileName: element)
                        info.setNumberOfPageAndThumbnail(fileCache.numberOfPage, thumbnail: fileCache.thumbnail)
                        resultList.append(info)
                    } else {
                        waitlist.append(SKInfo(dirPath: dirPath, fileName: element))
                    }
                } else {
                    waitlist.append(SKInfo(dirPath: dirPath, fileName: element))
                }
            }
        }
        return waitlist.count
    }
    
    private func runList() {
        if waitlist.count > 0 {
            if firstOnList.type == "PDF" {
                if let pdf = CGPDFDocumentCreateWithURL(NSURL(fileURLWithPath: firstOnList.filePath)) {
                    //  set cache info
                    firstOnList.setNumberOfPageAndThumbnail(pdf.numberOfPages, thumbnail: pdf.getPageImage(1)!.resize(withNewSize: SKStandard.thumbnailSize))
                    moveToResultList()
                } else {
                    /*  Do nothing  */
                }
            } else {
                webView = newWebView
                webView.loadRequest(filePath: firstOnList.filePath)
            }
        } else {
            //  store cache
            sharedCache.store()
            //  fire complete callback
            if ongoingAction == SKCacheManagerAction.retrieve {
                delegate?.retrievalDidFinish?(self, cache: resultList)
            } else if ongoingAction == SKCacheManagerAction.rebuild {
                delegate?.rebuildingDidFinish?(self, cache: resultList)
            }
        }
    }
    
    private func moveToResultList() {
        sharedCache.cacheIn(firstOnList)
        resultList.append(firstOnList)
        waitlist.removeFirst()
        if ongoingAction == SKCacheManagerAction.retrieve {
            delegate?.retrievalProgressReported?(self, percent: Float(resultList.count) / Float(totalWorkLoad) )
        } else if ongoingAction == SKCacheManagerAction.rebuild {
            delegate?.rebuildingProgressReported?(self, percent: Float(resultList.count) / Float(totalWorkLoad) )
        }
        runList()
    }
}
