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
        NotificationCenter.default.addObserver(self, selector: #selector(didRequestRightDrawer(_:)), name: StreamEvents.didRequestRightDrawer, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Retrieve OAuth tokens. If the tokens are absent, promote sign in screen
        let authService = AuthenticationService.sharedInstance
        if !authService.retrieveStoredOAuthTokens() {
            print("Tokens not found")
            
            // Show the sign in screen
            let greetingsViewController = GreetingsViewController(nibName: "GreetingsViewController", bundle: nil)
            self.present(greetingsViewController, animated: false, completion: nil)
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
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let topVC = visibleViewController {
            return topVC.supportedInterfaceOrientations
        } else {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    //MARK: DrawerOpenGestureControllerDelegate
    
    func drawerAnimationContextForInteractiveGesture() -> DrawerAnimationContext {
        return self.rightDrawerAnimationContext(true)
    }
    
    //MARK: Events
    
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
