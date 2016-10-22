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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back button
        self.view.addSubview(backButton)
        backButton.setImage(UIImage(named: "DetailBackButton"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        backButton.sizeToFit()
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
        f.origin.x = 10
        f.origin.y = 30
        backButton.frame = f
    }

    // MARK: - Events
    
    @objc func backButtonDidTap(_ sender : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
