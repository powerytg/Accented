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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidTap(_:)))
        
        webView.delegate = self
        startSignInRequest()
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
            self?.dismiss(animated: true, completion: nil)
            }) { [weak self ] (error) in
            self?.handleFailure(error.localizedDescription)
        }
    }
    
    fileprivate func handleFailure(_ message : String!) -> Void {
        let alert = UIAlertController(title: "Authentication Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { [weak self] (UIAlertAction) in
            self?.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func cancelButtonDidTap(_ sender: AnyObject!) -> Void {
        self.dismiss(animated: true, completion: nil)
    }

}
