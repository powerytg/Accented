//
//  UserProfileViewController.swift
//  Accented
//
//  User profile page
//
//  Created by Tiangong You on 5/27/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import RMessage

class UserProfileViewController: SectionViewController, MenuDelegate {

    private var user : UserModel
    private var loadingView : LoadingViewController?
    private var backgroundView : DesaturatedBackgroundView?

    // Sections
    private var headerSection : UserHeaderSectionView!
    private var infoSection : UserInfoSectionView!
    private var descSection : UserDescSectionView!
    private var gallerySection : UserGallerySection!
    private var recentPhotoSection : UserPhotoSectionView!
    
    // Menu
    private let followMenuItem = MenuItem(action: .Vote, text: "Add to Friends")
    private var signedInMenu = [MenuItem]()
    private var signedOutMenu = [MenuItem]()

    init(user : UserModel) {
        self.user = user
        super.init(nibName: "UserProfileViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.rootViewBackgroundColor
        
        // Initialize the loading progress view
        loadingView = LoadingViewController()
        loadingView!.loadingText = "Retrieving user profile"
        loadingView!.errorText = "Cannot load user profile"
        loadingView!.retryAction = { [weak self] in
            self?.loadUserProfile()
        }
        
        let loadingViewWidth : CGFloat = view.bounds.size.width
        let loadingViewHeight : CGFloat = 140
        loadingView!.view.frame = CGRect(x: 0,
                                         y: view.bounds.size.height / 2 - loadingViewHeight,
                                         width: loadingViewWidth,
                                         height: loadingViewHeight)
        addChildViewController(loadingView!)
        view.addSubview(loadingView!.view)
        loadingView!.didMove(toParentViewController: self)

        // Initialize sections
        initializeSections()
        
        // Always refresh the user profile regardless whether it's been loaded previously
        loadUserProfile()
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(userProfileDidUpdate(_:)), name: StorageServiceEvents.userProfileDidUpdate, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userFollowingStateDidChange(_:)), name: StorageServiceEvents.userFollowingStateDidUpdate, object: nil)
    }

    override func createMenuBar() {
        // Construct menu bar
        var hasFollowingMenuItem = false
        if user.following != nil {
            hasFollowingMenuItem = true
            if user.following! {
                followMenuItem.text = "Remove From Friends"
            } else {
                followMenuItem.text = "Add To Friends"
            }
        }
        
        signedInMenu = [MenuItem(action: .Home, text: "Home"),
                        followMenuItem,
                        MenuItem(action: .ViewUserPhotos, text: "View User's Photos"),
                        MenuItem(action: .ViewUserGalleries, text: "View User's Galleries"),
                        MenuItem(action: .ViewUserFriends, text: "View User's Friends")]
        
        // A user cannot follow himself/herself
        if StorageService.sharedInstance.currentUser == nil || user.userId == StorageService.sharedInstance.currentUser!.userId {
            hasFollowingMenuItem = false
        }

        if !hasFollowingMenuItem {
            if let index = signedInMenu.index(of: followMenuItem) {
                signedInMenu.remove(at: index)
            }
        }


        signedOutMenu = [MenuItem(action: .Home, text: "Home"),
                        MenuItem(action: .ViewUserPhotos, text: "View User's Photos"),
                        MenuItem(action: .ViewUserGalleries, text: "View User's Galleries"),
                        MenuItem(action: .ViewUserFriends, text: "View User's Friends")]
        
        if StorageService.sharedInstance.currentUser != nil {
            menuBar = CompactMenuBar(signedInMenu)
        } else {
            menuBar = CompactMenuBar(signedOutMenu)
        }
        
        menuBar!.delegate = self
        view.addSubview(menuBar!)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let background = backgroundView {
            background.frame = view.bounds
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func loadUserProfile() {
        let userId = self.user.userId
        APIService.sharedInstance.getUserProfile(userId: userId!, success: nil) { [weak self] (errorMessage) in
            self?.loadingView?.showErrorState()
        }
    }

    private func initializeSections() {
        headerSection = UserHeaderSectionView(user)
        descSection = UserDescSectionView(user)
        infoSection = UserInfoSectionView(user)
        gallerySection = UserGallerySection(user)
        recentPhotoSection = UserPhotoSectionView(user)
        
        addSection(headerSection)
        addSection(descSection)
        addSection(infoSection)
        addSection(gallerySection)
        addSection(recentPhotoSection)
        view.setNeedsLayout()
    }
    
    // Events
    @objc private func userProfileDidUpdate(_ notification : Notification) {
        let updatedUserId = notification.userInfo![StorageServiceEvents.userId] as! String
        guard updatedUserId == self.user.userId else { return }
        
        // Dismiss the loading view
        self.loadingView?.willMove(toParentViewController: nil)
        self.loadingView?.view.removeFromSuperview()
        self.loadingView?.removeFromParentViewController()
        self.loadingView = nil
        
        self.user = StorageService.sharedInstance.getUserProfile(userId: user.userId)!

        // Create menu bar
        createMenuBar()
        
        // If the user has a cover image, use it in place of default background
        backgroundView = DesaturatedBackgroundView()
        backgroundView?.contentMode = .scaleAspectFill
        view.insertSubview(backgroundView!, at: 0)
        backgroundView!.url = user.coverUrl
        
        descSection.model = user
        descSection.invalidateSize()
        
        infoSection.model = user
        infoSection.invalidate()
    }
    
    func didSelectMenuItem(_ menuItem: MenuItem) {
        switch menuItem.action {
        case .Home:
            NavigationService.sharedInstance.popToRootController(animated: true)
        case .Follow:
            followUser()
        case .ViewUserPhotos:
            NavigationService.sharedInstance.navigateToUserStreamPage(user: user)
        case .ViewUserGalleries:
            NavigationService.sharedInstance.navigateToUserGalleryListPage(user: user)
        case .ViewUserFriends:
            NavigationService.sharedInstance.navigateToUserFriendsPage(user: user)
        default:
            break
        }
    }
    
    private func followUser() {
        guard user.following != nil else { return }
        if user.following! {
            APIService.sharedInstance.unfollowUser(userId: user.userId, success: nil, failure: { (errorMessage) in
                RMessage.showNotification(withTitle: errorMessage, subtitle: nil, type: .error, customTypeName: nil, callback: nil)
            })
        } else {
            APIService.sharedInstance.followUser(userId: user.userId, success: nil, failure: { (errorMessage) in
                RMessage.showNotification(withTitle: errorMessage, subtitle: nil, type: .error, customTypeName: nil, callback: nil)
            })
        }
    }
    
    // Events
    @objc private func userFollowingStateDidChange(_ notification : Notification) {
        let updatedUser = notification.userInfo![StorageServiceEvents.user] as! UserModel
        guard updatedUser.userId == user.userId else { return }
        user.following = updatedUser.following
        guard user.following != nil else { return }
        
        if user.following! {
            RMessage.showNotification(withTitle: "You are now following this user", subtitle: nil, type: .success, customTypeName: nil, callback: nil)
            followMenuItem.text = "Remove From Friends"
        } else {
            RMessage.showNotification(withTitle: "You have stopped following this user", subtitle: nil, type: .success, customTypeName: nil, callback: nil)
            followMenuItem.text = "Add To Friends"
        }
    }
}
