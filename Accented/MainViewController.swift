//
//  MainViewController.swift
//  Accented
//
//  Created by Tiangong You on 4/10/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import SDWebImage

class MainViewController: UINavigationController, DrawerOpenGestureControllerDelegate {

    private var rightDrawerSize : CGSize
    private var rightDrawerGestureController : DrawerOpenGestureController?
    private var shouldShowSignInScreen = false
    
    // Main menu
    private var rightDrawer : UIViewController?
    
    required init?(coder aDecoder: NSCoder) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        rightDrawerSize = CGSize(width: screenWidth * MainMenuViewController.drawerWidthInPercentage, height: screenHeight)

        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.rootViewBackgroundColor
        self.setNavigationBarHidden(true, animated: false)
        
        // Initialize navigation service
        NavigationService.sharedInstance.initWithRootNavigationController(self)
        
        // When the app launches for the first time, decide whether to show the sign in screen
        let hasOAuthCredentials = AuthenticationService.sharedInstance.retrieveStoredOAuthTokens()
        let currentUser = AuthenticationService.sharedInstance.getCurrentUserInfoFromCache()
        if hasOAuthCredentials && currentUser != nil {
            shouldShowSignInScreen = false
        } else {
            shouldShowSignInScreen = true
        }
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(userDidSignIn(_:)), name: AuthenticationService.userDidSignIn, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidSkipSignIn(_:)), name: AuthenticationService.userDidSkipSignIn, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(userDidSignOut(_:)), name: AuthenticationService.userDidSignOut, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(didRequestRightDrawer(_:)), name: StreamEvents.didRequestRightDrawer, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Decide whether to show home stream or the greetings screen
        if shouldShowSignInScreen {
            shouldShowSignInScreen = false
            showGreetingsScreen()
        } else {
            proceedAfterSignIn()
        }
    }
    
    private func proceedAfterSignIn() {
        // Show the home view controller as root
        let homeViewController = HomeViewController()
        self.pushViewController(homeViewController, animated: false)
        
        // Setup drawers
        rightDrawer = MainMenuViewController()
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
    
    private func showGreetingsScreen() {
        let greetingsViewController = GreetingsViewController(nibName: "GreetingsViewController", bundle: nil)
        self.present(greetingsViewController, animated: false, completion: nil)
    }
    
    //MARK: DrawerOpenGestureControllerDelegate
    
    func drawerAnimationContextForInteractiveGesture() -> DrawerAnimationContext {
        return self.rightDrawerAnimationContext(true)
    }
    
    //MARK: Events
    
    @objc private func userDidSignIn(_ notification : Notification) {
        dismiss(animated: true) { 
            self.proceedAfterSignIn()
        }
    }
    
    @objc private func userDidSkipSignIn(_ notification : Notification) {
        dismiss(animated: true) {
            self.proceedAfterSignIn()
        }
    }
    
    @objc private func didRequestRightDrawer(_ notification : Notification) {
        let animationContext = self.rightDrawerAnimationContext(false)
        DrawerService.sharedInstance.presentDrawer(animationContext)
    }
    
    @objc private func userDidSignOut(_ notification : Notification) {
        StorageService.sharedInstance.signout()
        APIService.sharedInstance.signout()
        popToRootViewController(animated: false)
        
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
        
        // Return to greetings screen
        showGreetingsScreen()
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
