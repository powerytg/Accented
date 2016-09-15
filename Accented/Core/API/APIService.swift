//
//  APIService.swift
//  Accented
//
//  Created by You, Tiangong on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import OAuthSwift

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
    
    // API base url
    internal let baseUrl = "https://api.500px.com/v1/"
    
    // Supported image sizes
    internal let defaultImageSizesForStream = [ImageSize.Small, ImageSize.Medium, ImageSize.Large]
    
    // Singleton instance
    static let sharedInstance = APIService()
    fileprivate override init() {
        let authenticationService = AuthenticationService.sharedInstance
        client = OAuthSwiftClient(consumerKey: authenticationService.consumerKey,
                                  consumerSecret: authenticationService.consumerSecret,
                                  accessToken: authenticationService.accessToken!,
                                  accessTokenSecret: authenticationService.accessTokenSecret!)
    }
    
    // OAuth client for making API calls
    var client : OAuthSwiftClient
    
    // Comments expiration time (10 min)
    internal var commentsCacheAge : TimeInterval = 10 * 60
    
    // This dictionary keeps track of last refresh date
    internal var commentsLastRefreshedDateLookup = [String : Date]()
    
}
