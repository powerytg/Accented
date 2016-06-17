//
//  MainViewController.swift
//  Accented
//
//  Created by Tiangong You on 4/10/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class MainViewController: UINavigationController, DrawerGestureControllerDelegate {

    private var rightDrawerSize : CGSize
    
    private var homeViewController : HomeViewController?
    
    required init?(coder aDecoder: NSCoder) {
        let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let screenHeight = CGRectGetHeight(UIScreen.mainScreen().bounds)
        rightDrawerSize = CGSizeMake(screenWidth * ThemeSelectorViewController.drawerWidthInPercentage, screenHeight)

        super.init(coder: aDecoder)
    }
    
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
            self.homeViewController = HomeViewController()
            self.pushViewController(homeViewController!, animated: false)
            
            
            // Drawers
            DrawerService.sharedInstance.addInteractiveGesture(self.homeViewController!, anchor: .Right, drawerSize: rightDrawerSize, delegate: self)
        }
    }
    
    //MARK: DrawerGestureControllerDelegate
    
    func drawerViewControllerForInteractiveGesture() -> DrawerViewController {
        return DrawerViewController(drawer: ThemeSelectorViewController(), drawerSize: self.rightDrawerSize, anchor: .Right, interactive: false)
    }
    
    //MARK: Events
    
    func didRequestRightDrawer(notification : NSNotification) {
        let rightDrawer = DrawerViewController(drawer: ThemeSelectorViewController(), drawerSize: self.rightDrawerSize, anchor: .Right, interactive: false)
        DrawerService.sharedInstance.presentDrawer(rightDrawer, container: self)
    }
    
}
