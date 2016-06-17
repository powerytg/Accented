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
    private var rightDrawerGestureController : DrawerGestureController?
    
    // Theme selector
    private var rightDrawer : ThemeSelectorViewController?
    
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
            let homeViewController = HomeViewController()
            self.pushViewController(homeViewController, animated: false)
            
            // Setup drawers
            rightDrawer = ThemeSelectorViewController()
            let rightDrawerAnimationContext = self.rightDrawerAnimationContext(true)
            self.rightDrawerGestureController = DrawerService.sharedInstance.addInteractiveGesture(rightDrawerAnimationContext, delegate: self)
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    //MARK: DrawerGestureControllerDelegate
    
    func drawerAnimationContextForInteractiveGesture() -> DrawerAnimationContext {
        return self.rightDrawerAnimationContext(true)
    }
    
    //MARK: Events
    
    func didRequestRightDrawer(notification : NSNotification) {
        let animationContext = self.rightDrawerAnimationContext(false)
        DrawerService.sharedInstance.presentDrawer(animationContext)
    }
    
    //MARK: Private
    
    func rightDrawerAnimationContext(interactive : Bool) -> DrawerAnimationContext {
        let animationContext = DrawerAnimationContext(content : rightDrawer!)
        animationContext.container = self
        animationContext.drawerSize = rightDrawerSize
        animationContext.anchor = .Right
        animationContext.interactive = interactive
        
        return animationContext
    }
    
}
