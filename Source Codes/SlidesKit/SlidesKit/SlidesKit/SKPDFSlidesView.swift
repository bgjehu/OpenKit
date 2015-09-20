//
//  SKPDFSlidesView.swift
//  initialSlidesKit
//
//  Created by Jieyi Hu on 8/28/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit

internal class SKPDFSlidesView: UIImageView, SKBaseSlidesView {
    
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
    private var PDF : CGPDFDocument! = nil
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
        PDF = CGPDFDocumentCreateWithURL(NSURL(fileURLWithPath: filePath))
        _numberOfPages = self.PDF.numberOfPages
        gotoPage(1)
        slidesDidLoad?()
    }
    internal func gotoPage(pageNumber : Int){
        if pageNumber >= 1 && pageNumber <= numberOfPages {
            _currentPage = pageNumber
            self.image = PDF.getPageImage(currentPage)
        }
    }

}
