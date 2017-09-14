//
//  GreetingsViewController.swift
//  Accented
//
//  Created by You, Tiangong on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class GreetingsViewController: UIViewController {

    @IBOutlet weak var logoView: SignInLogoView!
    @IBOutlet weak var titleView: UIImageView!
    @IBOutlet weak var subTitleView: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var skipSignInButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    
    private var animationStarted = false
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize animation states
        self.logoView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        self.titleView.alpha = 0
        self.titleView.transform = CGAffineTransform(translationX: 0, y: 30)
        
        self.subTitleView.alpha = 0
        self.subTitleView.transform = CGAffineTransform(translationX: 0, y: 30)
        
        self.signInButton.alpha = 0
        self.signInButton.transform = CGAffineTransform(translationX: 0, y: 30)

        self.skipSignInButton.alpha = 0
        self.skipSignInButton.transform = CGAffineTransform(translationX: 0, y: 30)

        termsButton.alpha = 0
        termsButton.transform = CGAffineTransform(translationX: 0, y: 30)

        // Events
        signInButton.addTarget(self, action: #selector(signInButtonDidTap(_:)), for: UIControlEvents.touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Play entrance animation only once
        if !animationStarted {
            animationStarted = true
            self.performEntranceAnimation()
        }
    }
    
    func performEntranceAnimation() {
        let animationOptions: UIViewAnimationOptions = .curveEaseOut
        let keyframeAnimationOptions: UIViewKeyframeAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: animationOptions.rawValue)
        
        UIView.animateKeyframes(withDuration: 1.4, delay: 0.4, options: keyframeAnimationOptions, animations: { [weak self] in
            // Logo
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.8, animations: {
                self?.logoView.alpha = 1
                self?.logoView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
            
            // Title
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4, animations: {
                self?.titleView.alpha = 1
                self?.titleView.transform = CGAffineTransform.identity
                
                self?.termsButton.alpha = 1
                self?.termsButton.transform = CGAffineTransform.identity
            })
            
            // Sub title
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.4, animations: {
                self?.subTitleView.alpha = 1
                self?.subTitleView.transform = CGAffineTransform.identity
            })
            
            // Sign in button
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                self?.signInButton.alpha = 1
                self?.signInButton.transform = CGAffineTransform.identity
            })

            // Skip Sign in button
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                self?.skipSignInButton.alpha = 1
                self?.skipSignInButton.transform = CGAffineTransform.identity
            })

            }, completion: { [weak self] (Bool) in
                self?.logoView.performPerspectiveAnimation()
        })
    }
    
    func signInButtonDidTap(_ sender:UIButton!) {
        let webViewController = SignInViewController()
        let navController = UINavigationController(rootViewController: webViewController)
        present(navController, animated: true, completion: nil)
    }

    @IBAction func skipSignInButtonDidTap(_ sender: Any) {
        AuthenticationService.sharedInstance.skipSignIn()
        APIService.sharedInstance.skipSignIn()
        NotificationCenter.default.post(name: AuthenticationService.userDidSkipSignIn, object: nil)
    }
    
    @IBAction func termsButtonDidTap(_ sender: Any) {
        let webViewController = TermsViewController()
        let navController = UINavigationController(rootViewController: webViewController)
        present(navController, animated: true, completion: nil)
    }
}
