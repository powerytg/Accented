//
//  HomeViewController.swift
//  Accented
//
//  Created by You, Tiangong on 5/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, StreamViewControllerDelegate {

    var backgroundView : BlurredBackbroundView?
    var streamViewController : HomeStreamViewController?
    var stream : StreamModel?
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar
        applyStatusBarStyle()
        
        // Background
        backgroundView = BlurredBackbroundView()
        self.view.addSubview(backgroundView!)
        backgroundView!.frame = self.view.bounds
        backgroundView!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        // If the stream has no content, show the loading view
        createStreamViewController(StorageService.sharedInstance.currentStream.streamType)
        
        // Events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(streamDidUpdate(_:)), name: StorageServiceEvents.streamDidUpdate, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(streamSelectionWillChange(_:)), name: StreamEvents.streamSelectionWillChange, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(appThemeDidChange(_:)), name: ThemeManagerEvents.appThemeDidChange, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createStreamViewController(streamType : StreamType) {
        stream = StorageService.sharedInstance.getStream(streamType)
        streamViewController = HomeStreamViewController()
        streamViewController!.stream = stream
        addChildViewController(streamViewController!)
        self.view.addSubview(streamViewController!.view)
        streamViewController!.view.frame = self.view.bounds
        streamViewController!.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        streamViewController!.didMoveToParentViewController(self)
        streamViewController!.delegate = self
    }
    
    func streamDidUpdate(notification : NSNotification) -> Void {
        let streamTypeString = notification.userInfo![StorageServiceEvents.streamType] as! String
        let streamType = StreamType(rawValue: streamTypeString)
        if streamType == stream?.streamType && stream!.photos.count != 0 {
            backgroundView!.photo = stream!.photos[0]
            backgroundView!.setNeedsLayout()
        }
    }
    
    // MARK: - Events
    func streamSelectionWillChange(notification : NSNotification) {
        let streamTypeString = notification.userInfo![StreamEvents.selectedStreamType] as! String
        let streamType = StreamType(rawValue: streamTypeString)
        
        if streamType == stream!.streamType {
            return
        }
        
        StorageService.sharedInstance.currentStream = StorageService.sharedInstance.getStream(streamType!)
        stream = StorageService.sharedInstance.currentStream
        
        streamViewController?.stream = stream
    }
    
    func appThemeDidChange(notification : NSNotification) {
        applyStatusBarStyle()
    }
    
    // MARK: - Private
    
    private func applyStatusBarStyle() {
        UIApplication.sharedApplication().statusBarStyle = ThemeManager.sharedInstance.currentTheme.statusBarStyle
    }
    
    // MARK: - StreamViewControllerDelegate
    func streamViewDidFinishedScrolling(firstVisiblePhoto: PhotoModel) {
        //        backgroundView!.photo = firstVisiblePhoto
        //        backgroundView!.setNeedsLayout()
    }

}
