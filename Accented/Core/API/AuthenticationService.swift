//
//  AuthenticationService.swift
//  Accented
//
//  Created by You, Tiangong on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import OAuthSwift

class AuthenticationService: NSObject {
    
    typealias SuccessAction = (credentials: OAuthSwiftCredential) -> Void
    typealias FailureAction = (error: NSError) -> Void
    
    let consumerKey = "CF0WTWPsQXuEl83X35pfEus8VaYPOORFyjGFsIex"
    let consumerSecret = "blOsQK7uj8YHnSnZYoaSkkituD334OL51M80hV4S"
    
    static let callbackUrl = "accented-app://auth"
    
    private static let accessTokenStoreKey = "accessToken";
    private static let accessTokenSecretStoreKey = "accessTokenSecret"
    var accessToken : String?
    var accessTokenSecret : String?
    
    // Redirect url host once user has authenticated the app
    static let oauthHost = "auth"
    
    // Singleton instance
    static let sharedInstance = AuthenticationService()
    
    private override init() {
        // Ignore
    }

    func retrieveStoredOAuthTokens() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        self.accessToken = userDefaults.stringForKey(AuthenticationService.accessTokenStoreKey)
        self.accessTokenSecret = userDefaults.stringForKey(AuthenticationService.accessTokenSecretStoreKey)
        
        return (accessToken != nil && accessTokenSecret != nil)
    }
    
    func startSignInRequest(urlHandler:OAuthSwiftURLHandlerType, success: SuccessAction, failure: FailureAction) {
        let authenticator = OAuth1Swift(
            consumerKey:   consumerKey,
            consumerSecret: consumerSecret,
            requestTokenUrl: "https://api.500px.com/v1/oauth/request_token",
            authorizeUrl: "https://api.500px.com/v1/oauth/authorize",
            accessTokenUrl: "https://api.500px.com/v1/oauth/access_token"
        )
        
        authenticator.authorize_url_handler = urlHandler
        authenticator.authorizeWithCallbackURL(
            NSURL(string: "accented-app://auth")!,
            success: {[weak self] credential, response, parameters in
                // Store access token and secret
                if let weakSelf = self {
                    weakSelf.accessToken = credential.oauth_token
                    weakSelf.accessTokenSecret = credential.oauth_token_secret
                    
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setObject(weakSelf.accessToken, forKey: AuthenticationService.accessTokenStoreKey)
                    userDefaults.setObject(weakSelf.accessTokenSecret, forKey: AuthenticationService.accessTokenSecretStoreKey)
                    userDefaults.synchronize()
                }
                
                // Notify of success event
                success(credentials: credential)
            },
            failure: { error in
                failure(error: error)
            }
        )
    }

}
