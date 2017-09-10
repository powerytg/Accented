//
//  MainViewController.swift
//  Accented
//
//  Created by Tiangong You on 4/10/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import SDWebImage

class MainViewController: UINavigationController {

    private var shouldShowSignInScreen = false
    
    required init?(coder aDecoder: NSCoder) {
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
            StorageService.sharedInstance.currentUser = currentUser
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        SDImageCache.shared().clearMemory()
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
    
    //MARK: Events
    
    @objc private func userDidSignIn(_ notification : Notification) {
        dismiss(animated: true) { 
            self.proceedAfterSignIn()
        }
    }
    
    @objc private func userDidSkipSignIn(_ notification : Notification) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.presentedViewController?.view.alpha = 0
        }) { [weak self] (finished) in
            self?.dismiss(animated: false) { [weak self] in
                self?.proceedAfterSignIn()
            }
        }
    }
    
    @objc private func didRequestRightDrawer(_ notification : Notification) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let drawerSize = CGSize(width: screenWidth * MainMenuViewController.drawerWidthInPercentage, height: screenHeight)
        let drawer = MainMenuViewController()
        
        let animationContext = DrawerAnimationContext(content: drawer)
        animationContext.anchor = .right
        animationContext.container = self
        animationContext.drawerSize = CGSize(width: drawerSize.width, height: drawerSize.height)
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
}
