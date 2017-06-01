//
//  TextUtils.swift
//  Accented
//
//  Created by You, Tiangong on 5/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class TextUtils: NSObject {
    static func streamDisplayName(_ streamType : StreamType) -> String {
        switch streamType {
        case .Popular:
            return "Popular Photos"
        case .Editors:
            return "Editors' Choice"
        case .FreshToday:
            return "Fresh Today"
        case .FreshWeek:
            return "Fresh This Week"
        case .FreshYesterday:
            return "Fresh Yesterday"
        case .HighestRated:
            return "Highest Rated"
        case .Upcoming:
            return "Upcoming Photos"
        case .User:
            return "User Photos"
        case .Search:
            return "Search Result"
        case .UserFriends:
            return "Photos From Your Friends"
        }
    }
    
    static func streamCondensedDisplayName(_ streamType : StreamType) -> String {
        switch streamType {
        case .Popular:
            return "Popular"
        case .Editors:
            return "Editors' Choice"
        case .FreshToday:
            return "Today"
        case .FreshWeek:
            return "This Week"
        case .FreshYesterday:
            return "Fresh Yesterday"
        case .HighestRated:
            return "Highest Rated"
        case .Upcoming:
            return "Upcoming"
        case .User:
            return "User"
        case .Search:
            return "Search Result"
        case .UserFriends:
            return "Photos From Your Friends"
        }
    }
    
    static func preferredAuthorName(_ user : UserModel) -> String {
        if let name = user.fullName {
            return name
        } else if let name = user.firstName {
            return name
        } else  {
            return user.userName
        }
    }

    static func sortOptionDisplayName(_ option : PhotoSearchSortingOptions) -> String {
        switch option {
        case .createdAt:
            return "Latest"
        case .highestRating:
            return "Top Rated"
        case .rating:
            return "Most Popular"
        case .timesViewed:
            return "Most Viewed"
        }
    }    
}
