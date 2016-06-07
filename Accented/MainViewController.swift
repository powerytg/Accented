//
//  MainViewController.swift
//  Accented
//
//  Created by Tiangong You on 4/10/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class MainViewController: UINavigationController {

    private let drawerTransitionDelegate = DrawerAnimationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.rootViewBackgroundColor
        self.setNavigationBarHidden(true, animated: false)
        
        // Events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didRequestRightDrawer(_:)), name: StreamEvents.didRequestRightDrawer, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Retrieve OAuth tokens. If the tokens are absent, promote sign in screen
        let authService = AuthenticationService.sharedInstance
        if !authService.retrieveStoredOAuthTokens() {
            // Show the sign in screen
            let greetingsViewController = GreetingsViewController(nibName: "GreetingsViewController", bundle: nil)
            self.presentViewController(greetingsViewController, animated: false, completion: nil)
        } else {
            // Show the home view controller as root
            let homeViewController = HomeViewController()
            self.pushViewController(homeViewController, animated: false)
        }
    }
    
    // MARK: Events
    
    func didRequestRightDrawer(notification : NSNotification) {
        let rightDrawer = DrawerViewController(viewController: ThemeSelectorViewController(), anchor: .Right)
        rightDrawer.modalPresentationStyle = .Custom
        rightDrawer.transitioningDelegate = self.drawerTransitionDelegate
        self.presentViewController(rightDrawer, animated: true, completion: nil)
    }
    
}
