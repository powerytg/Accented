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

class UserProfileViewController: SectionViewController {

    private var user : UserModel
    private var loadingView : LoadingViewController?
    private var backgroundView : DesaturatedBackgroundView?

    // Sections
    private var headerSection : UserHeaderSectionView!
    private var infoSection : UserInfoSectionView!
    private var descSection : UserDescSectionView!
    private var gallerySection : UserGallerySection!
    private var recentPhotoSection : UserPhotoSectionView!
    
    init(user : UserModel) {
        self.user = user
        super.init(nibName: "UserProfileViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
}
