//
//  UserFollowersSectionViewController.swift
//  Accented
//
//  Followers section in user profile page
//
//  Created by Tiangong You on 5/28/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserFollowersSectionViewController: UserProfileCardViewController {

    var streamViewController : UserFollowersStreamViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "FOLLOWERS"
        
        let stream : UserFollowersModel = StorageService.sharedInstance.getUserFollowers(userId: user.userId)
        streamViewController = UserFollowersStreamViewController(stream)
        addChildViewController(streamViewController)
        self.view.addSubview(streamViewController.view)
        streamViewController.view.frame = self.view.bounds
        streamViewController.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        streamViewController.view.frame = view.bounds
    }
}
