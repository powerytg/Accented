//
//  HomeViewController.swift
//  Accented
//
//  Created by You, Tiangong on 5/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, InfiniteLoadingViewControllerDelegate {

    var backgroundView : ThemeableBackgroundView?
    var streamViewController : HomeStreamViewController?
    var stream : StreamModel?
    
    // Whether the entrance animation has been performed
    // This flag will be reset after theme change
    var entranceAnimationPerformed = false
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar
        applyStatusBarStyle()
        
        // Background
        backgroundView = ThemeManager.sharedInstance.currentTheme.backgroundViewClass.init()
        self.view.addSubview(backgroundView!)
        backgroundView!.frame = self.view.bounds
        backgroundView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Initialize stream
        createStreamViewController(StorageService.sharedInstance.currentStream.streamType)
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(streamDidUpdate(_:)), name: StorageServiceEvents.streamDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(streamSelectionWillChange(_:)), name: StreamEvents.streamSelectionWillChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appThemeDidChange(_:)), name: ThemeManagerEvents.appThemeDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createStreamViewController(_ streamType : StreamType) {
        stream = StorageService.sharedInstance.getStream(streamType)
        streamViewController = HomeStreamViewController()
        streamViewController!.stream = stream
        addChildViewController(streamViewController!)
        self.view.addSubview(streamViewController!.view)
        streamViewController!.view.frame = self.view.bounds
        streamViewController!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        streamViewController!.didMove(toParentViewController: self)
        streamViewController!.delegate = self
    }
    
    @objc private func streamDidUpdate(_ notification : Notification) {
        let streamTypeString = notification.userInfo![StorageServiceEvents.streamType] as! String
        let streamType = StreamType(rawValue: streamTypeString)
        if streamType == stream?.streamType && stream!.photos.count != 0 {
            // Perform entrance animation if necessary
            if !entranceAnimationPerformed {
                entranceAnimationPerformed = true
                
                backgroundView!.photo = stream!.photos[0]
                backgroundView!.setNeedsLayout()
                backgroundView!.performEntranceAnimation({
                    // Ignore
                })
            }
        }
    }
    
    // MARK: - Events
    @objc private func streamSelectionWillChange(_ notification : Notification) {
        let streamTypeString = notification.userInfo![StreamEvents.selectedStreamType] as! String
        let streamType = StreamType(rawValue: streamTypeString)
        
        if streamType == stream!.streamType {
            return
        }
        
        StorageService.sharedInstance.currentStream = StorageService.sharedInstance.getStream(streamType!)
        stream = StorageService.sharedInstance.currentStream
        
        streamViewController?.stream = stream
    }
    
    @objc private func appThemeDidChange(_ notification : Notification) {
        applyStatusBarStyle()
        
        // Remove the previous background view and apply the new background along with entrance animation
        backgroundView!.removeFromSuperview()
        
        backgroundView! = ThemeManager.sharedInstance.currentTheme.backgroundViewClass.init()
        backgroundView!.frame = self.view.bounds
        backgroundView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView!.photo = stream!.photos[0]

        self.view.insertSubview(backgroundView!, at: 0)
        backgroundView!.performEntranceAnimation({
            // Ignore
        })
    }
    
    // MARK: - Private
    
    private func applyStatusBarStyle() {
        UIApplication.shared.statusBarStyle = ThemeManager.sharedInstance.currentTheme.statusBarStyle
    }
    
    // MARK: - InfiniteLoadingViewControllerDelegate

    func collectionViewContentOffsetDidChange(_ contentOffset: CGFloat) {
        backgroundView!.streamViewContentOffsetDidChange(contentOffset)
    }
}
