//
//  APIService+Cache.swift
//  Accented
//
//  Created by Tiangong You on 8/20/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

extension APIService {
    
    // Check whether a specific photo has expired comments
    internal func commentsCacheExpired(_ photoId : String) -> Bool {
        guard let lastRefreshedDate = commentsLastRefreshedDateLookup[photoId] else { return false }
        let age = lastRefreshedDate.timeIntervalSinceNow
        return (age >= commentsCacheAge)
    }
}
