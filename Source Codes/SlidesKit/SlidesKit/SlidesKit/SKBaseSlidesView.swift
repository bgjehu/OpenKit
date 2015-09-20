//
//  SKBaseSlidesView.swift
//  initialSlidesKit
//
//  Created by Jieyi Hu on 8/28/15.
//  Copyright © 2015 SenseWatch. All rights reserved.
//

import UIKit

internal protocol SKBaseSlidesView {
    var numberOfPages : Int {get}
    var currentPage : Int {get}
    var view : UIView {get}
    func load(filaPath : String, slidesDidLoad : (()->())?)
    func gotoPage(pageNumber : Int)
}
