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
        }
    }
}
