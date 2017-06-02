//
//  APIService+Gallery.swift
//  Accented
//
//  APIService gallery extension
//
//  Created by You, Tiangong on 6/2/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

extension APIService {
    
    // Get user galleries
    func getGalleries(userId : String, page : Int = 1, parameters:[String : String] = [:], success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) {
        let request = GetGalleriesRequest(userId, page : page, params: parameters, success : success, failure : failure)
        get(request: request)
    }
}
