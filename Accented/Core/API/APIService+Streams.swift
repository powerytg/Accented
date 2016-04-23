//
//  APIService+Streams.swift
//  Accented
//
//  Created by You, Tiangong on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

extension APIService {

    // Get photos from stream
    func getPhotos(streamType : StreamType, page : Int = 1, parameters:[String : String] = [:]) -> Void {
        let url = "\(baseUrl)photos"
        var params = parameters
        params["feature"] = streamType.rawValue
        params["page"] = String(page)
        params["image_size"] = "4"
        
        client.get(url, parameters: params, success: { (data, response) in
            let userInfo : [String : AnyObject] = ["streamType" : streamType.rawValue,
                "page" : page, "response" : data]
            NSNotificationCenter.defaultCenter().postNotificationName("streamPhotosDidReturn", object: nil, userInfo: userInfo)
            }) { (error) in
                let userInfo : [String : String] = ["errorMessage" : error.localizedDescription]
                NSNotificationCenter.defaultCenter().postNotificationName("streamPhotosFailedReturn", object: nil, userInfo: userInfo)
        }
    }
    
}
