//
//  UserGalleryListViewController.swift
//  Accented
//
//  User gallery list page
//
//  Created by You, Tiangong on 9/1/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserGalleryListViewController: UIViewController {
    
    private let headerCompressionStart : CGFloat = 50
    private let headerCompressionDist : CGFloat = 200
    private var streamViewController : UserGalleryListStreamViewController!
    private var user : UserModel
    private var backButton = UIButton(type: .custom)
    private var headerView : UserHeaderSectionView!
    private var backgroundView : DetailBackgroundView!
    
    private let displayStyles = [MenuItem("Display As Groups"),
                                 MenuItem("Display As List")]
    
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
        
        self.view.backgroundColor = UIColor.black
        backgroundView = DetailBackgroundView(frame: self.view.bounds)
        self.view.insertSubview(backgroundView, at: 0)
        
        // Header view
        headerView = UserHeaderSectionView(user)
        view.addSubview(headerView)
        
        // Stream controller
        createStreamViewController()
        
        // Back button
        self.view.addSubview(backButton)
        backButton.setImage(UIImage(named: "DetailBackButton"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        backButton.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        streamViewController.view.frame = view.bounds
        streamViewController.view.setNeedsLayout()
        
        var f = headerView.frame
        f.size.width = view.bounds.size.width
        headerView.frame = f
        headerView.setNeedsLayout()
        
        f = backButton.frame
        f.origin.x = 10
        f.origin.y = 30
        backButton.frame = f
    }
    
    private func createStreamViewController() {
        let galleryList = StorageService.sharedInstance.getUserGalleries(userId: user.userId)
        streamViewController = UserGalleryListStreamViewController(galleryCollection: galleryList)
        addChildViewController(streamViewController)
        
        self.view.insertSubview(streamViewController.view, at: 1)
        streamViewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        streamViewController.didMove(toParentViewController: self)
    }
    
    // MARK: - Events
    
    @objc private func backButtonDidTap(_ sender : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - InfiniteLoadingViewControllerDelegate
    
    func collectionViewContentOffsetDidChange(_ contentOffset: CGFloat) {
        var dist = contentOffset - headerCompressionStart
        dist = min(headerCompressionDist, max(0, dist))
        headerView.alpha = 1 - (dist / headerCompressionDist)
        
        // Apply background effects
        backgroundView.applyScrollingAnimation(contentOffset)
    }
}
