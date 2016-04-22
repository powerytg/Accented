//
//  SignInViewController.swift
//  Accented
//
//  Created by Tiangong You on 4/10/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var logoView: SignInLogoView!
    @IBOutlet weak var titleView: UIImageView!
    @IBOutlet weak var subTitleView: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize animation states
        self.logoView.transform = CGAffineTransformMakeScale(0.6, 0.6)
        
        self.titleView.alpha = 0
        self.titleView.transform = CGAffineTransformMakeTranslation(0, 30)
        
        self.subTitleView.alpha = 0
        self.subTitleView.transform = CGAffineTransformMakeTranslation(0, 30)
        
        self.signInButton.alpha = 0
        self.signInButton.transform = CGAffineTransformMakeTranslation(0, 30)
        
        // Events
        signInButton.addTarget(self, action: #selector(signInButtonDidTap(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Play entrance animation only once
        self.performEntranceAnimation()
    }
    
    func performEntranceAnimation() {
        var token: dispatch_once_t = 0
        dispatch_once(&token) {
            let animationOptions: UIViewAnimationOptions = .CurveEaseOut
            let keyframeAnimationOptions: UIViewKeyframeAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: animationOptions.rawValue)
            
            UIView.animateKeyframesWithDuration(1.4, delay: 0.4, options: keyframeAnimationOptions, animations: {
                // Logo
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.8, animations: { 
                    self.logoView.alpha = 1
                    self.logoView.transform = CGAffineTransformMakeScale(0.8, 0.8)
                })
                
                // Title
                UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.4, animations: { 
                    self.titleView.alpha = 1
                    self.titleView.transform = CGAffineTransformIdentity
                })
                
                // Sub title
                UIView.addKeyframeWithRelativeStartTime(0.4, relativeDuration: 0.4, animations: {
                    self.subTitleView.alpha = 1
                    self.subTitleView.transform = CGAffineTransformIdentity
                })

                // Sign in button
                UIView.addKeyframeWithRelativeStartTime(0.6, relativeDuration: 0.4, animations: {
                    self.signInButton.alpha = 1
                    self.signInButton.transform = CGAffineTransformIdentity
                })

                }, completion: { (Bool) in
                self.logoView.performPerspectiveAnimation()
            })
        }
    }
    
    func signInButtonDidTap(sender:UIButton!) {
        let webViewController = ACSignInWebViewController()
        let navController = UINavigationController(rootViewController: webViewController)
        presentViewController(navController, animated: true, completion: nil)
    }
}
