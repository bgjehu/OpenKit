//
//  CGPDFDocument.swift
//  SlidesKit
//
//  Created by Jieyi Hu on 9/13/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

public extension CGPDFDocument {
    
    var numberOfPages : Int {
        let numberOfPages = CGPDFDocumentGetNumberOfPages(self)
        return numberOfPages
    }
    
    func getPageImage(pageNumber : Int) -> UIImage? {
        
        // http://stackoverflow.com/questions/4639781/rendering-a-cgpdfpage-into-a-uiimage
        
        if pageNumber <= self.numberOfPages {
            
            //  Get the page
            let page = CGPDFDocumentGetPage(self, pageNumber)
            
            let pageRect = CGPDFPageGetBoxRect(page, CGPDFBox.MediaBox)
            
            //  Set up box and rect
            
            UIGraphicsBeginImageContext(pageRect.size)
            
            let context = UIGraphicsGetCurrentContext()
            
            //  White Background
            CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
            CGContextFillRect(context, pageRect)
            CGContextSaveGState(context)
            
            // Next 3 lines makes the rotations so that the page look in the right direction
            CGContextTranslateCTM(context, 0.0, pageRect.size.height)
            CGContextScaleCTM(context, 1.0, -1.0)
            CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(page, CGPDFBox.MediaBox, pageRect, 0, true))
            
            
            CGContextDrawPDFPage(context, page)
            CGContextRestoreGState(context)
            
            let img = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return img
            
        } else {
            return nil
        }
    }
}