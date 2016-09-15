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
    func getPhotos(_ streamType : StreamType, page : Int = 1, parameters:[String : String] = [:], success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) -> Void {
        let url = "\(baseUrl)photos"
        var params = parameters
        params["feature"] = streamType.rawValue
        params["page"] = String(page)
        if parameters["image_size"] == nil {
            params["image_size"] = defaultImageSizesForStream.map({ (size) -> String in
                return size.rawValue
            }).joined(separator: ",")
        }
        
        _ = client.get(url, parameters: params, success: { (data, response) in
            let userInfo : [String : Any] = ["streamType" : streamType.rawValue,
                "page" : page, "response" : data]
            NotificationCenter.default.post(name: Notification.Name("streamPhotosDidReturn"), object: nil, userInfo: userInfo)
            
            if let successAction = success {
                successAction()
            }

            }) { (error) in
                let userInfo : [String : String] = ["errorMessage" : error.localizedDescription]
                NotificationCenter.default.post(name: Notification.Name("streamPhotosFailedReturn"), object: nil, userInfo: userInfo)
                
                if let failureAction = failure {
                    failureAction(error.localizedDescription)
                }
        }
    }
    
}
