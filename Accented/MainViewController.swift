//
//  MainViewController.swift
//  Accented
//
//  Created by Tiangong You on 4/10/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class MainViewController: UINavigationController, DrawerOpenGestureControllerDelegate {

    fileprivate var rightDrawerSize : CGSize
    fileprivate var rightDrawerGestureController : DrawerOpenGestureController?
    
    // Theme selector
    fileprivate var rightDrawer : ThemeSelectorViewController?
    
    required init?(coder aDecoder: NSCoder) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        rightDrawerSize = CGSize(width: screenWidth * ThemeSelectorViewController.drawerWidthInPercentage, height: screenHeight)

        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.rootViewBackgroundColor
        self.setNavigationBarHidden(true, animated: false)
        
        // Initialize navigation service
        NavigationService.sharedInstance.initWithRootNavigationController(self)
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(userDidSignIn(_:)), name: AuthenticationService.userDidSignIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRequestRightDrawer(_:)), name: StreamEvents.didRequestRightDrawer, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Retrieve OAuth tokens. If the tokens are absent, prompt the user to the sign in screen
        let authService = AuthenticationService.sharedInstance
        if !authService.retrieveStoredOAuthTokens() {
            debugPrint("Tokens not found")
            showSignInScreen()
            return
        }
        
        // Retrieve current user info. If not found (or cannot read), prompt the user to the sign in screen
        let currentUser = authService.getCurrentUserInfoFromCache()
        if currentUser == nil {
            debugPrint("Current user info not found")
            showSignInScreen()
            return
        }
        
        proceedAfterSignIn()
    }
    
    fileprivate func proceedAfterSignIn() {
        // Show the home view controller as root
        let homeViewController = HomeViewController()
        self.pushViewController(homeViewController, animated: false)
        
        // Setup drawers
        rightDrawer = ThemeSelectorViewController()
        let rightDrawerAnimationContext = self.rightDrawerAnimationContext(true)
        self.rightDrawerGestureController = DrawerService.sharedInstance.addInteractiveGesture(rightDrawerAnimationContext, delegate: self)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let topVC = visibleViewController {
            return topVC.supportedInterfaceOrientations
        } else {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    fileprivate func showSignInScreen() {
        let greetingsViewController = GreetingsViewController(nibName: "GreetingsViewController", bundle: nil)
        self.present(greetingsViewController, animated: false, completion: nil)
    }
    
    //MARK: DrawerOpenGestureControllerDelegate
    
    func drawerAnimationContextForInteractiveGesture() -> DrawerAnimationContext {
        return self.rightDrawerAnimationContext(true)
    }
    
    //MARK: Events
    
    @objc fileprivate func userDidSignIn(_ notification : Notification) {
        dismiss(animated: true) { 
            self.proceedAfterSignIn()
        }
    }
    
    func didRequestRightDrawer(_ notification : Notification) {
        let animationContext = self.rightDrawerAnimationContext(false)
        DrawerService.sharedInstance.presentDrawer(animationContext)
    }
    
    //MARK: Private
    
    func rightDrawerAnimationContext(_ interactive : Bool) -> DrawerAnimationContext {
        let animationContext = DrawerAnimationContext(content : rightDrawer!)
        animationContext.container = self
        animationContext.drawerSize = rightDrawerSize
        animationContext.anchor = .right
        animationContext.interactive = interactive
        
        return animationContext
    }
    
}
