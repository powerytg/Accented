//
//  SignInViewController.swift
//  Accented
//
//  Created by You, Tiangong on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import OAuthSwift

class SignInViewController: UIViewController, UIWebViewDelegate, OAuthSwiftURLHandlerType {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var progressView: UIStackView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTap(_:)))
        
        webView.delegate = self
        startSignInRequest()
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(currentUserInfoDidReturn(_:)), name: APIEvents.currentUserProfileDidReturn, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handle(_ url: URL) {
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
    
    func startSignInRequest() {
        AuthenticationService.sharedInstance.startSignInRequest(self, success: {[weak self] (credentials) in
            self?.showRequestUserInfoView()
            }) { [weak self ] (error) in
            self?.handleFailure(error.localizedDescription)
        }
    }
    
    private func handleFailure(_ message : String!) -> Void {
        let alert = UIAlertController(title: "Authentication Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { [weak self] (UIAlertAction) in
            self?.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func cancelButtonDidTap(_ sender: AnyObject!) -> Void {
        self.dismiss(animated: true, completion: nil)
    }

    private func showRequestUserInfoView() {
        self.progressView.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.webView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.size.height)
            self?.webView.alpha = 0
            self?.progressView.alpha = 1
            self?.indicator.startAnimating()
        }) { [weak self] (finished) in
            // Initialize API clients
            APIService.sharedInstance.initialize()
            
            self?.requestCurrentUserInfo()
        }
    }
    
    private func requestCurrentUserInfo() {
        APIService.sharedInstance.getCurrentUserProfile(success: nil) { [weak self] (errorMessage) in
            self?.indicator.stopAnimating()
            self?.handleFailure(errorMessage)
        }
    }
    
    @objc private func currentUserInfoDidReturn(_ notification : Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.indicator.stopAnimating()
            
            let jsonData : Data = notification.userInfo![RequestParameters.response] as! Data
            if let currentUser = StorageService.sharedInstance.userFromJson(jsonData) {
                let jsonString = String(data: jsonData, encoding: .utf8)
                AuthenticationService.sharedInstance.putCurrentUserInfoToCache(userJson: jsonString!)
                StorageService.sharedInstance.currentUser = currentUser
                StorageService.sharedInstance.putUserProfileToCache(currentUser)
                
                // Go back to the home screen
                NotificationCenter.default.post(name: AuthenticationService.userDidSignIn, object: nil)
            }
        }
    }
}
