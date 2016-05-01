//
//  GatewayViewController.swift
//  Accented
//
//  Created by Tiangong You on 4/29/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class GatewayViewController: UIViewController, StreamViewControllerDelegate {
    
    var backgroundView : BlurredBackbroundView?
    var streamViewController : StreamViewController?
    var stream : StreamModel?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName : "GatewayViewController", bundle: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Background
        backgroundView = BlurredBackbroundView()
        self.view.addSubview(backgroundView!)
        backgroundView!.frame = self.view.bounds
        backgroundView!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        streamViewController = StreamViewController()
        addChildViewController(streamViewController!)
        self.view.addSubview(streamViewController!.view)
        streamViewController!.view.frame = self.view.bounds
        streamViewController!.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        streamViewController!.didMoveToParentViewController(self)
        streamViewController!.delegate = self
        
        // Load initial stream
        stream = StorageService.sharedInstance.getStream(StreamType.Popular)
        streamViewController!.stream = stream
        
        // Events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(streamDidUpdate(_:)), name: StorageServiceEvents.streamDidUpdate, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func streamDidUpdate(notification : NSNotification) -> Void {
        let streamTypeString = notification.userInfo![StorageServiceEvents.streamType] as! String
        let streamType = StreamType(rawValue: streamTypeString)
        if streamType == stream?.streamType && stream!.photos.count != 0 {
            backgroundView!.photo = stream!.photos[0]
            backgroundView!.setNeedsLayout()
        }
    }

    // MARK: - StreamViewControllerDelegate
    func streamViewDidFinishedScrolling(firstVisiblePhoto: PhotoModel) {
//        backgroundView!.photo = firstVisiblePhoto
//        backgroundView!.setNeedsLayout()
    }
    
}
