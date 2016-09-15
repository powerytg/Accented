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
    
    typealias SuccessAction = (_ credentials: OAuthSwiftCredential) -> Void
    typealias FailureAction = (_ error: NSError) -> Void
    
    let consumerKey = "CF0WTWPsQXuEl83X35pfEus8VaYPOORFyjGFsIex"
    let consumerSecret = "blOsQK7uj8YHnSnZYoaSkkituD334OL51M80hV4S"
    
    static let callbackUrl = "accented-app://auth"
    
    fileprivate static let accessTokenStoreKey = "accessToken";
    fileprivate static let accessTokenSecretStoreKey = "accessTokenSecret"
    var accessToken : String?
    var accessTokenSecret : String?
    
    // Redirect url host once user has authenticated the app
    static let oauthHost = "auth"
    
    // Singleton instance
    static let sharedInstance = AuthenticationService()
    
    fileprivate override init() {
        // Ignore
    }

    func retrieveStoredOAuthTokens() -> Bool {
        let userDefaults = UserDefaults.standard
        self.accessToken = userDefaults.string(forKey: AuthenticationService.accessTokenStoreKey)
        self.accessTokenSecret = userDefaults.string(forKey: AuthenticationService.accessTokenSecretStoreKey)
        
        return (accessToken != nil && accessTokenSecret != nil)
    }
    
    func startSignInRequest(_ urlHandler:OAuthSwiftURLHandlerType, success: @escaping SuccessAction, failure: @escaping FailureAction) {
        let authenticator = OAuth1Swift(
            consumerKey:   consumerKey,
            consumerSecret: consumerSecret,
            requestTokenUrl: "https://api.500px.com/v1/oauth/request_token",
            authorizeUrl: "https://api.500px.com/v1/oauth/authorize",
            accessTokenUrl: "https://api.500px.com/v1/oauth/access_token"
        )
        
        authenticator.authorize_url_handler = urlHandler
        authenticator.authorizeWithCallbackURL(
            URL(string: "accented-app://auth")!,
            success: {[weak self] credential, response, parameters in
                // Store access token and secret
                if let weakSelf = self {
                    weakSelf.accessToken = credential.oauth_token
                    weakSelf.accessTokenSecret = credential.oauth_token_secret
                    
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(weakSelf.accessToken, forKey: AuthenticationService.accessTokenStoreKey)
                    userDefaults.set(weakSelf.accessTokenSecret, forKey: AuthenticationService.accessTokenSecretStoreKey)
                    userDefaults.synchronize()
                }
                
                // Notify of success event
                success(credential)
            },
            failure: { error in
                print("Auth error: " + error.localizedDescription)
                failure(error)
            }
        )
    }

}
