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
// Note that this is only a psudo definition and does not necessarily match the API specification
enum StreamType : String {
    case Popular = "popular"
    case HighestRated = "highest_rated"
    case Upcoming = "upcoming"
    case Editors = "editors"
    case FreshToday = "fresh_today"
    case FreshYesterday = "fresh_yesterday"
    case FreshWeek = "fresh_week"
    case User = "user"  // User photos
    case UserFriends = "user_friends" // User friends photos
    case Search = "search"  // Search result
}

// Image size definitions
enum ImageSize : String {
    case Small = "30"   // 256px on the longest side
    case Medium = "31"  // 450px high
    case Large = "4"    // 900px on the longest side
}

// Photo Search Sorting options
enum PhotoSearchSortingOptions : String {
    case createdAt = "created_at" // Default: sort by time of upload, most recent first
    case rating = "rating" // Sort by current rating, highest rated first
    case highestRating = "highest_rating" // Sort by highest rating achieved, highest rated first
    case timesViewed = "times_viewed" // Sort by the number of views, most viewed first
    
    // Below options are not supported by the app
    // case score = "_score" // Sort by query score, best match first
    // case votesCount = "votes_count" // Sort by the number of votes, most voted on first
    // case commentsCount = "comments_count" // Sort by the number of comments, most commented first
}

class APIService: NSObject {
    
    // Singleton instance
    static let sharedInstance = APIService()
    fileprivate override init() {
        let authenticationService = AuthenticationService.sharedInstance
        client = OAuthSwiftClient(consumerKey: authenticationService.consumerKey,
                                  consumerSecret: authenticationService.consumerSecret,
                                  oauthToken: authenticationService.accessToken!,
                                  oauthTokenSecret: authenticationService.accessTokenSecret!,
                                  version: .oauth1)
        
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
