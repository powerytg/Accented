//
//  ACOAuthManager.swift
//  Accented
//
//  Created by Tiangong You on 4/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import OAuthSwift

class ACOAuthManager: NSObject {

    // Singleton instance
    static let sharedInstance = ACOAuthManager()
    
    private override init() {
        authenticator = OAuth1Swift(
            consumerKey:   consumerKey,
            consumerSecret: consumerSecret,
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
            accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
        )
    }
    
    private let consumerKey = "CF0WTWPsQXuEl83X35pfEus8VaYPOORFyjGFsIex"
    private let consumerSecret = "blOsQK7uj8YHnSnZYoaSkkituD334OL51M80hV4S"
    
    static let callbackUrl = "accented-app://auth"
    
    private let accessTokenStoreKey = "accessToken";
    private let accessTokenSecretStoreKey = "accessTokenSecret"
    private var accessToken : String?
    private var accessTokenSecret : String?
    
    // Delegate for handling auth redirect
    weak var authUrlHandler : OAuthSwiftURLHandlerType?
    
    // Redirect url host once user has authenticated the app
    static let oauthHost = "auth"
    
    // Auth
    private let authenticator : OAuth1Swift
    
    func retrieveStoredOAuthTokens() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        accessToken = userDefaults.stringForKey(accessTokenStoreKey)
        accessTokenSecret = userDefaults.stringForKey(accessTokenSecretStoreKey)
        
        return (accessToken != nil && accessTokenSecret != nil)
    }
}
