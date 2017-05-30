//
//  UserProfileCardViewController.swift
//  Accented
//
//  Base view controller for a user profile page card
//
//  Created by Tiangong You on 5/29/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserProfileCardViewController: CardViewController {

    var user : UserModel
    
    init(user : UserModel, nibName : String? = nil) {
        self.user = user
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
