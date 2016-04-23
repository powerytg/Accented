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
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancelButtonDidTap(_:)))
        
        webView.delegate = self
        startSignInRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handle(url: NSURL) {
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
    
    func startSignInRequest() {
        AuthenticationService.sharedInstance.startSignInRequest(self, success: {[weak self] (credentials) in
            self?.dismissViewControllerAnimated(true, completion: nil)
            }) { [weak self ] (error) in
            self?.handleFailure(error.localizedDescription)
        }
    }
    
    private func handleFailure(message : String!) -> Void {
        let alert = UIAlertController(title: "Authentication Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: { [weak self] (UIAlertAction) in
            self?.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func cancelButtonDidTap(sender: AnyObject!) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
