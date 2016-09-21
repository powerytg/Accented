//
//  APIService.swift
//  Accented
//
//  Created by You, Tiangong on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import OAuthSwift
import AwesomeCache

// Stream definitions
enum StreamType : String {
    case Popular = "popular"
    case HighestRated = "highest_rated"
    case Upcoming = "upcoming"
    case Editors = "editors"
    case FreshToday = "fresh_today"
    case FreshYesterday = "fresh_yesterday"
    case FreshWeek = "fresh_week"
    case User = "user"
}

// Image size definitions
enum ImageSize : String {
    case Small = "30"   // 256px on the longest side
    case Medium = "31"  // 450px high
    case Large = "4"    // 900px on the longest side
}

class APIService: NSObject {
    
    // Singleton instance
    static let sharedInstance = APIService()
    fileprivate override init() {
        let authenticationService = AuthenticationService.sharedInstance
        client = OAuthSwiftClient(consumerKey: authenticationService.consumerKey,
                                  consumerSecret: authenticationService.consumerSecret,
                                  accessToken: authenticationService.accessToken!,
                                  accessTokenSecret: authenticationService.accessTokenSecret!)
        
        super.init()
        
        // Initialize cache
        initializeCache()
    }
    
    // OAuth client for making API calls
    var client : OAuthSwiftClient
    
    // HTTP cache
    internal var cacheController : Cache<NSData>?
 
    // Cache expiration
    // Default: 5 minutes
    internal var cacheExpiration = CacheExpiry.seconds(1000 * 10)
    
    // On-going API requests
    internal var pendingRequestQueue = [String]()
    
}
