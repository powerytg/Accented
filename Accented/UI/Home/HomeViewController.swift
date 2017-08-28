//
//  HomeViewController.swift
//  Accented
//
//  Created by You, Tiangong on 5/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, InfiniteLoadingViewControllerDelegate, MenuDelegate {

    var backgroundView : ThemeableBackgroundView?
    var streamViewController : HomeStreamViewController?
    var menuBar : CompactMenuBar!
    
    let menuItems = [MenuItem("Search"),
                     MenuItem("Take Photo"),
                     MenuItem("Sign Out")]

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
        
        // Compact menu bar
        createMenuBar()
        
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
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let streamController = streamViewController {
            var f = streamController.view.frame
            f.size.width = view.bounds.width
            f.size.height = view.bounds.height - CompactMenuBar.defaultHeight
            streamController.view.frame = f
        }
        
        var f = menuBar.frame
        f.size.width = view.bounds.width
        f.size.height = CompactMenuBar.defaultHeight
        f.origin.y = view.bounds.height - f.size.height
        menuBar.frame = f
    }
    
    // MARK : - Stream
    
    private func createStreamViewController(_ streamType : StreamType) {
        let stream = StorageService.sharedInstance.getStream(streamType)
        streamViewController = HomeStreamViewController(stream)
        addChildViewController(streamViewController!)
        self.view.addSubview(streamViewController!.view)
        streamViewController!.view.frame = self.view.bounds
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
    
    // MARK: - Menu
    
    private func createMenuBar() {
        menuBar = CompactMenuBar(menuItems)
        menuBar.delegate = self
        view.addSubview(menuBar)
    }
    
    // MARK: - MenuDelegate
    
    func didSelectMenuItem(_ menuItem: MenuItem) {
        let index = menuItems.index(of: menuItem)
        guard index != nil else { return }
        switch index! {
        case 0:
            let searchViewController = SearchViewController()
            present(searchViewController, animated: true, completion: nil)
        case 1:
            NavigationService.sharedInstance.navigateToCamera()
        case 2:
            NavigationService.sharedInstance.signout()
        default:
            break
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
