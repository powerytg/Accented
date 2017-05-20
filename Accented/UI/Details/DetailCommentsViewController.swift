//
//  DetailCommentsViewController.swift
//  Accented
//
//  Created by You, Tiangong on 10/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailCommentsViewController: InfiniteLoadingViewController {
    
    // Photo model
    var photo : PhotoModel!    
    
    // Collection view viewModel
    fileprivate var commentsViewModel : CommentsViewModel! {
        return viewModel as! CommentsViewModel
    }
    
    // Back button
    fileprivate var backButton = UIButton(type: .custom)

    // Compose button
    fileprivate var composeButton = UIButton()
    
    // Margins
    fileprivate var vPadding : CGFloat = 30
    fileprivate var hPadding : CGFloat = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back button
        self.view.addSubview(backButton)
        backButton.setImage(UIImage(named: "DetailBackButton"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        backButton.sizeToFit()
        
        // Compose button
        self.view.addSubview(composeButton)
        composeButton.setTitle("ADD COMMENT", for: .normal)
        composeButton.addTarget(self, action: #selector(composeButtonDidTap(_:)), for: .touchUpInside)
        composeButton.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func createViewModel() {
        viewModel = CommentsViewModel(photo.photoId, collectionView : collectionView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var f = backButton.frame
        f.origin.x = hPadding
        f.origin.y = vPadding
        backButton.frame = f
        
        f = composeButton.frame
        f.origin.x = view.bounds.size.width - f.size.width - hPadding
        f.origin.y = 30
        composeButton.frame = f
    }

    // MARK: - Events
    
    @objc func backButtonDidTap(_ sender : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @objc func composeButtonDidTap(_ sender : UIButton) {
        let composerViewController = DetailComposerViewController()
        present(composerViewController, animated: true, completion: nil)
    }
}
