//
//  SKSlidesView.swift
//  initialSlidesKit
//
//  Created by Jieyi Hu on 8/28/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit

internal enum SKSlidesViewContentType {
    case PPT
    case PDF
}

public class SKSlidesView: UIView {

    private var viewsFrame : CGRect {
        get{
            return CGRectMake(0, 0, 200, 150)
        }
    }
    private var baseView : SKBaseSlidesView!
    private var contentType : SKSlidesViewContentType = .PDF {
        didSet{
            if oldValue != contentType {
                newBaseView(contentType)
            }
        }
    }
    
    public var delegate : SKSlidesViewDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initComponents()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initComponents()
    }
    private func initComponents() {
        userInteractionEnabled = false
        newBaseView(.PDF)
    }
    private func newBaseView(type : SKSlidesViewContentType) {
        //  remove old baseView
        if baseView != nil {
            baseView.view.removeFromSuperview()
        }
        //  init new baseView
        baseView = type == .PDF ? SKPDFSlidesView(frame: viewsFrame) : SKPPTSlidesView(frame: viewsFrame)
        //  add to mainView
        addSubview(baseView.view)
        //  pad mainView
        paddedWithView(baseView.view)
    }
    public func load(filePath : String) {
        
        if filePath.slidesExist() {
            if filePath.uppercaseString.hasSuffix("PDF") {
                contentType = .PDF
            } else {
                contentType = .PPT
            }
            baseView.load(filePath, slidesDidLoad: slidesDidLoad)
        } else {
            print("SKSlidesViewController Error: Cannot load slides with invalid filePath = \(filePath)")
        }
    }
    
    private func slidesDidLoad() {
        delegate?.slidesViewDidFinishLoad(self)
    }
    
    public func gotoPage(pageNumber : Int) {
        baseView.gotoPage(pageNumber)
    }
    
    public func nextPage(){
        gotoPage(baseView.currentPage + 1)
    }
    public func prevPage(){
        gotoPage(baseView.currentPage - 1)
    }
    public func firstPage(){
        gotoPage(1)
    }
    public func finalPage(){
        gotoPage(baseView.numberOfPages)
    }

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
