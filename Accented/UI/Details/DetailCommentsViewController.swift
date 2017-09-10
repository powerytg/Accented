//
//  DetailCommentsViewController.swift
//  Accented
//
//  Created by You, Tiangong on 10/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailCommentsViewController: InfiniteLoadingViewController<CommentModel> {
    
    // Photo model
    var photo : PhotoModel!
    
    // Collection view viewModel
    private var commentsViewModel : CommentsViewModel! {
        return viewModel as! CommentsViewModel
    }
    
    // Back button
    private var backButton = UIButton(type: .custom)
    
    // Compose button
    private var composeButton = UIButton()
    
    // Nav bar
    private var navBarView = UIVisualEffectView(effect : UIBlurEffect(style : .dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        // Nav bar
        self.view.addSubview(navBarView)
        
        // Back button
        self.view.addSubview(backButton)
        backButton.setImage(UIImage(named: "DetailBackButton"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        backButton.sizeToFit()
        
        // Compose button
        self.view.addSubview(composeButton)
        composeButton.setTitle("ADD COMMENT", for: .normal)
        composeButton.titleLabel?.font = ThemeManager.sharedInstance.currentTheme.navButtonFont
        composeButton.addTarget(self, action: #selector(composeButtonDidTap(_:)), for: .touchUpInside)
        composeButton.sizeToFit()
        
        // Only registerd user can post comments
        composeButton.isHidden = (StorageService.sharedInstance.currentUser == nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func createViewModel() {
        let comments = StorageService.sharedInstance.getComments(photo.photoId)
        viewModel = CommentsViewModel(collection: comments, collectionView: collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let currentTheme = ThemeManager.sharedInstance.currentTheme
        
        var f = navBarView.frame
        f.size.width = view.bounds.size.width
        f.size.height = currentTheme.navBarHeight
        navBarView.frame = f
        
        f = backButton.frame
        f.origin.x = currentTheme.navContentLeftPadding
        f.origin.y = currentTheme.navContentTopPadding
        backButton.frame = f
        
        f = composeButton.frame
        f.origin.x = view.bounds.size.width - f.size.width - currentTheme.navContentLeftPadding
        f.origin.y = currentTheme.navContentTopPadding
        composeButton.frame = f
    }
    
    // MARK: - Events
    
    @objc func backButtonDidTap(_ sender : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func composeButtonDidTap(_ sender : UIButton) {
        let composerViewController = DetailComposerViewController(photo : photo)
        present(composerViewController, animated: true, completion: nil)
    }
}
