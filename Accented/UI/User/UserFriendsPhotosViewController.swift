//
//  UserFriendsPhotosViewController.swift
//  Accented
//
//  Created by Tiangong You on 9/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserFriendsPhotosViewController: UIViewController, InfiniteLoadingViewControllerDelegate, MenuDelegate {
    
    private let headerCompressionStart : CGFloat = 50
    private let headerCompressionDist : CGFloat = 200
    private var streamViewController : UserFriendsPhotosStreamViewController!
    private var user : UserModel
    private var backButton = UIButton(type: .custom)
    private var headerView : UserHeaderSectionView!
    private var backgroundView : DetailBackgroundView!
    
    private let displayStyles = [MenuItem(action: .None, text: "Display As Groups"),
                                 MenuItem(action: .None, text: "Display As List")]
    
    // Menu
    private var menu = [MenuItem(action : .Home, text: "Home")]
    private var menuBar : CompactMenuBar!

    init(user : UserModel) {
        // Get an updated copy of user profile
        self.user = StorageService.sharedInstance.getUserProfile(userId: user.userId)!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.rootViewBackgroundColor
        backgroundView = DetailBackgroundView(frame: self.view.bounds)
        self.view.insertSubview(backgroundView, at: 0)
        
        // Header view
        headerView = UserHeaderSectionView(user)
        view.addSubview(headerView)
        
        // Stream controller
        createStreamViewController(.group, animated: false)
        
        // Back button
        self.view.addSubview(backButton)
        if ThemeManager.sharedInstance.currentTheme is DarkTheme {
            backButton.setImage(UIImage(named: "DetailBackButton"), for: .normal)
        } else {
            backButton.setImage(UIImage(named: "LightDetailBackButton"), for: .normal)
        }

        backButton.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        backButton.sizeToFit()
        
        // Create a menu
        menuBar = CompactMenuBar(menu)
        menuBar.delegate = self
        view.addSubview(menuBar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRequestChangeDisplayStyle(_:)), name: StreamEvents.didRequestChangeDisplayStyle, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        backgroundView.frame = view.bounds
        
        streamViewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - CompactMenuBar.defaultHeight)
        streamViewController.view.setNeedsLayout()
        
        var f = headerView.frame
        f.size.width = view.bounds.size.width
        headerView.frame = f
        headerView.setNeedsLayout()
        
        f = backButton.frame
        f.origin.x = 10
        f.origin.y = 30
        backButton.frame = f
        
        f = menuBar.frame
        f.origin.x = 0
        f.origin.y = view.bounds.height - CompactMenuBar.defaultHeight
        f.size.width = view.bounds.width
        f.size.height = CompactMenuBar.defaultHeight
        menuBar.frame = f
    }
    
    private func createStreamViewController(_ style : StreamDisplayStyle, animated : Bool) {
        let stream = StorageService.sharedInstance.getStream(.UserFriends)
        streamViewController = UserFriendsPhotosStreamViewController(user: user, stream: stream, style : style)
        addChildViewController(streamViewController)
        
        if animated {
            streamViewController.view.alpha = 0
            self.streamViewController.view.transform = CGAffineTransform(translationX: 0, y: -20)
        }
        
        self.view.insertSubview(streamViewController.view, at: 1)
        streamViewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        streamViewController.didMove(toParentViewController: self)
        streamViewController.delegate = self
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.streamViewController.view.alpha = 1
                self.streamViewController.view.transform = CGAffineTransform.identity
            })
        }
    }
    
    // MARK: - Events
    
    @objc private func backButtonDidTap(_ sender : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didRequestChangeDisplayStyle(_ notification : Notification) {
        let menuViewController = MenuViewController(displayStyles)
        menuViewController.title = "DISPLAY STYLE"
        menuViewController.delegate = self
        menuViewController.show()
    }
    
    // MARK: - InfiniteLoadingViewControllerDelegate
    
    func collectionViewContentOffsetDidChange(_ contentOffset: CGFloat) {
        var dist = contentOffset - headerCompressionStart
        dist = min(headerCompressionDist, max(0, dist))
        headerView.alpha = 1 - (dist / headerCompressionDist)
        
        // Apply background effects
        backgroundView.applyScrollingAnimation(contentOffset)
    }
    
    // MARK : - MenuDelegate
    
    func didSelectMenuItem(_ menuItem: MenuItem) {
        if menuItem.action == .Home {
            NavigationService.sharedInstance.popToRootController(animated: true)
            return
        }

        let index = displayStyles.index(of: menuItem)
        var selectedStyle : StreamDisplayStyle
        if index == 0 {
            selectedStyle = .group
        } else if index == 1 {
            selectedStyle = .card
        } else {
            debugPrint("Unrecognized display style")
            return
        }
        
        // Remove the previous stream view controller
        UIView.animate(withDuration: 0.2, animations: {
            self.streamViewController.view.alpha = 0
            self.streamViewController.view.transform = CGAffineTransform(translationX: 0, y: 20)
        }) { (finished) in
            self.streamViewController.willMove(toParentViewController: nil)
            self.streamViewController.view.removeFromSuperview()
            self.streamViewController.removeFromParentViewController()
            
            self.createStreamViewController(selectedStyle, animated: true)
        }
    }
}
