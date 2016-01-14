
//
//  SlidesViewController.swift
//  SlidesKitSample
//
//  Created by Jieyi Hu on 9/2/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

import UIKit
import SlidesKit

class SlidesViewController: UIViewController, SKSlidesViewDelegate {
    
    
    var hideButtonTimestamp = NSDate()
    @IBOutlet weak var slidesView: SKSlidesView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet var shakeImage: UIImageView!
    @IBAction func nextButtonClicked(sender: UIButton) {
        slidesView.nextPage()
        deleyButtonHiding(5)
    }
    @IBAction func prevButtonClicked(sender: UIButton) {
        slidesView.prevPage()
        deleyButtonHiding(5)
    }
    @IBAction func homeButtonClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        slidesView.delegate = self
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func loadSlides(info : SKInfo) {
        loadingIndicator.hidden = false
        slidesView.hidden = true
        slidesView.load(info.filePath)
    }
    
    internal func showButtons() {
        nextButton.hidden = false
        prevButton.hidden = false
        homeButton.hidden = false
    }
    func deleyButtonHiding(interval : NSTimeInterval) {
        hideButtonTimestamp = NSDate(timeIntervalSinceNow: interval)
    }
    internal func hideButtons(interval : NSTimeInterval) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(interval * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            let diff = self.hideButtonTimestamp.timeIntervalSinceNow
            if diff <= 0 {
                self.nextButton.hidden = true
                self.prevButton.hidden = true
                self.homeButton.hidden = true
            } else {
                self.hideButtons(diff)
            }
        }
    }
    
    func slidesViewDidFinishLoad(slidesView: SKSlidesView) {
        loadingIndicator.hidden = true
        slidesView.hidden = false
        showShakeImageOnce()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == UIEventSubtype.MotionShake {
            if !shakeImage.hidden {
                shakeImage.hidden = true
            }
            showButtons()
            hideButtons(5)
        }
    }
    
    func showShakeImageOnce() {
        if !NSUserDefaults.standardUserDefaults().boolForKey("ShowedShakeImage") {
            shakeImage.hidden = false
            view.bringSubviewToFront(shakeImage)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ShowedShakeImage")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
