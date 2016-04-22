//
//  ACSignInWebViewController.swift
//  Accented
//
//  Created by Tiangong You on 4/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import OAuthSwift

class ACSignInWebViewController: UIViewController, UIWebViewDelegate, OAuthSwiftURLHandlerType {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let oauthController = OAuth1Swift(
            consumerKey:    "********",
            consumerSecret: "********",
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
            accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
        )
        
        oauthController.authorize_url_handler = self
        
        oauthController.authorizeWithCallbackURL(
            NSURL(string: "oauth-swift://oauth-callback/twitter")!,
            success: { credential, response, parameters in
                print(credential.oauth_token)
                print(credential.oauth_token_secret)
                print(parameters["user_id"])
            },
            failure: { error in
                print(error.localizedDescription)
            }             
        )
    }

}
