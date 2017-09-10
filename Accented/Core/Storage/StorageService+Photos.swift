//
//  StorageService+Photos.swift
//  Accented
//
//  Created by Tiangong You on 9/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import SwiftyJSON

extension StorageService {

    internal func photoVoteDidUpdate(_ notification : Notification) -> Void {
        let jsonData : Data = notification.userInfo![RequestParameters.response] as! Data
        parsingQueue.async {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions())
                let json = JSON(jsonObject)
                let photoJson = json["photo"]
                let photo = PhotoModel(json: photoJson)
                
                DispatchQueue.main.async {
                    let userInfo : [String : Any] = [StorageServiceEvents.photo : photo]
                    NotificationCenter.default.post(name: StorageServiceEvents.photoDidUpdate, object: nil, userInfo: userInfo)
                }
            } catch {
                debugPrint(error)
            }
        }
    }    
}
