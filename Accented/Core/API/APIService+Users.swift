//
//  APIService+Users.swift
//  Accented
//
//  User APIs
//
//  Created by Tiangong You on 5/22/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

extension APIService {
    
    // Search for users
    func searchUsers(keyword : String, page : Int = 1, success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) {
        let request = SearchUsersRequest(keyword : keyword, page : page, success : success, failure : failure)
        get(request: request)
    }

}
