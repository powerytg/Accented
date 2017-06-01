//
//  UserPhotosSectionViewController.swift
//  Accented
//
//  User photos section in the profile page
//
//  Created by Tiangong You on 5/28/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserPhotosSectionViewController: UserProfileCardViewController {

    var streamViewController : UserStreamViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "PHOTOS"
        
        // Initialize stream
        let stream = StorageService.sharedInstance.getUserStream(userId: user.userId)
        streamViewController = UserStreamViewController(stream)
        addChildViewController(streamViewController)
        self.view.addSubview(streamViewController.view)
        streamViewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        streamViewController.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        streamViewController.view.frame = view.bounds
        streamViewController.view.setNeedsLayout()
    }
}
