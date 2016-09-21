//
//  APIService+Comments.swift
//  Accented
//
//  Created by You, Tiangong on 8/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

extension APIService {

    // Get comments for a photo
    func getComments(_ photoId : String, page : Int = 1, parameters:[String : String] = [:], success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) -> Void {
        let request = GetCommentsRequest(photoId, page : page, params : parameters, success : success, failure : failure)
        get(request: request)

    }
}
