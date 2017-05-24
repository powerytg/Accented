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
        
        // Testing code
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { 
            NavigationService.sharedInstance.navigateToSearchResultPage(keyword : "landscape")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createStreamViewController(_ streamType : StreamType) {
        let stream = StorageService.sharedInstance.getStream(streamType)
        streamViewController = HomeStreamViewController(stream)
        addChildViewController(streamViewController!)
        self.view.addSubview(streamViewController!.view)
        streamViewController!.view.frame = self.view.bounds
        streamViewController!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        streamViewController!.didMove(toParentViewController: self)
        streamViewController!.delegate = self
    }
    
    @objc private func streamDidUpdate(_ notification : Notification) {
        let streamId = notification.userInfo![StorageServiceEvents.streamId] as! String
        let photos : [PhotoModel] = notification.userInfo![StorageServiceEvents.photos] as! [PhotoModel]
        if streamId == streamViewController?.stream.streamId && photos.count != 0 {
            // Perform entrance animation on background view if necessary
            if !entranceAnimationPerformed {
                entranceAnimationPerformed = true
                
                backgroundView!.photo = photos[0]
                backgroundView!.setNeedsLayout()
                backgroundView!.performEntranceAnimation({
                    // Ignore
                })
            }
        }
    }
    
    // MARK: - Events
    @objc private func streamSelectionWillChange(_ notification : Notification) {
        guard streamViewController != nil else { return }
        let streamTypeString = notification.userInfo![StreamEvents.selectedStreamType] as! String
        let streamType = StreamType(rawValue: streamTypeString)
        if streamType == streamViewController!.stream.streamType {
            return
        }
        
        StorageService.sharedInstance.currentStream = StorageService.sharedInstance.getStream(streamType!)
        streamViewController!.switchStream(StorageService.sharedInstance.currentStream)
    }
    
    @objc private func appThemeDidChange(_ notification : Notification) {
        applyStatusBarStyle()
        
        // Remove the previous background view and apply the new background along with entrance animation
        let backgroundPhoto = backgroundView!.photo
        backgroundView!.removeFromSuperview()
        
        backgroundView! = ThemeManager.sharedInstance.currentTheme.backgroundViewClass.init()
        backgroundView!.frame = self.view.bounds
        backgroundView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView!.photo = backgroundPhoto

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
