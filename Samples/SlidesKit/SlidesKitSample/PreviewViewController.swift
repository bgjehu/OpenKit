//
//  PreviewViewController.swift
//  SlidesKitSample
//
//  Created by Jieyi Hu on 9/1/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

import UIKit
import SlidesKit

class PreviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SKCacheManagerDelegate {
    
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet var tableView: UITableView!
    
    let cacheManager = SKCacheManager()
    
    var dataSource : [SKInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cacheManager.delegate = self
        let slidesDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        cacheManager.retrieve(slidesDir)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath)
        (cell.contentView.viewWithTag(1) as! UIImageView).image = dataSource?[indexPath.row].thumbnail
        (cell.contentView.viewWithTag(2) as! UILabel).text = dataSource?[indexPath.row].fileName
        (cell.contentView.viewWithTag(3) as! UILabel).text = dataSource?[indexPath.row].type
        (cell.contentView.viewWithTag(4) as! UILabel).text = String(dataSource![indexPath.row].numberOfPages)
        (cell.contentView.viewWithTag(5) as! UILabel).text = dataSource?[indexPath.row].modificationData
        (cell.contentView.viewWithTag(6) as! UILabel).text = dataSource?[indexPath.row].creationData
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let slidesViewController = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("SlidesViewController")
        self.presentViewController(slidesViewController, animated: true, completion: {(slidesViewController as! SlidesViewController).loadSlides(self.dataSource![indexPath.row])})
    }
    
    func retrievalDidFinish(cacheManager: SKCacheManager, cache: [SKInfo]) {
        dataSource = cache
        tableView.reloadData()
        coverView.hidden = true
    }
    
    func retrievalProgressReported(cacheManager: SKCacheManager, percent: Float) {
        progressView.progress = percent
    }
    
    func rebuildingDidFinish(cacheManager: SKCacheManager, cache: [SKInfo]) {
        dataSource = cache
        tableView.reloadData()
        coverView.hidden = true
    }
    
    func rebuildingProgressReported(cacheManager: SKCacheManager, percent: Float) {
        progressView.progress = percent
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == UIEventSubtype.MotionShake {
            let alert = UIAlertController(title: nil, message: "Update Content", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {action in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {action in
                let slidesDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
                self.coverView.hidden = false
                self.cacheManager.rebuildCache(slidesDir)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

