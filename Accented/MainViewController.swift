//
//  MainViewController.swift
//  Accented
//
//  Created by Tiangong You on 4/10/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Retrieve OAuth tokens. If the tokens are absent, promote sign in screen
        let authService = AuthenticationService.sharedInstance
        if !authService.retrieveStoredOAuthTokens() {
            let greetingsViewController = GreetingsViewController(nibName: "GreetingsViewController", bundle: nil)
            self.presentViewController(greetingsViewController, animated: false, completion: nil)
        } else {
            let storageService = StorageService.sharedInstance
            APIService.sharedInstance.getPhotos(StreamType.Popular)
        }
        
    }
    
}
