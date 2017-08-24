//
//  UserPhotosViewController.swift
//  Accented
//
//  Created by Tiangong You on 8/23/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserPhotosViewController: UIViewController, InfiniteLoadingViewControllerDelegate {

    private let headerCompressionStart : CGFloat = 50
    private let headerCompressionDist : CGFloat = 200
    private var streamViewController : UserStreamViewController!
    private var user : UserModel
    private var backButton = UIButton(type: .custom)
    private var headerView : UserHeaderSectionView!
    
    init(user : UserModel) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Header view
        headerView = UserHeaderSectionView(user)
        view.addSubview(headerView)
        
        // Stream controller
        let stream = StorageService.sharedInstance.getUserStream(userId: user.userId)
        streamViewController = UserStreamViewController(user: user, stream: stream)
        addChildViewController(streamViewController)
        self.view.addSubview(streamViewController.view)
        streamViewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        streamViewController.didMove(toParentViewController: self)
        streamViewController.delegate = self
        
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
    
    // MARK: - Events
    
    @objc private func backButtonDidTap(_ sender : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - InfiniteLoadingViewControllerDelegate
    
    func collectionViewContentOffsetDidChange(_ contentOffset: CGFloat) {
        var dist = contentOffset - headerCompressionStart
        dist = min(headerCompressionDist, max(0, dist))
        headerView.alpha = 1 - (dist / headerCompressionDist)
    }

}
