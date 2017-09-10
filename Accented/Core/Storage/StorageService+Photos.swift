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

    internal func photoDidVote(_ notification : Notification) -> Void {
        let jsonData : Data = notification.userInfo![RequestParameters.response] as! Data
        parsingQueue.async {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions())
                let json = JSON(jsonObject)
                let photoJson = json["photo"]
                let photo = PhotoModel(json: photoJson)
                photo.voted = true
                
                DispatchQueue.main.async {
                    let userInfo : [String : Any] = [StorageServiceEvents.photo : photo]
                    NotificationCenter.default.post(name: StorageServiceEvents.photoVoteDidUpdate, object: nil, userInfo: userInfo)
                }
            } catch {
                debugPrint(error)
            }
        }
    }
    
    internal func photoDidUnVote(_ notification : Notification) -> Void {
        let jsonData : Data = notification.userInfo![RequestParameters.response] as! Data
        parsingQueue.async {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions())
                let json = JSON(jsonObject)
                let photoJson = json["photo"]
                let photo = PhotoModel(json: photoJson)
                photo.voted = false
                
                DispatchQueue.main.async {
                    let userInfo : [String : Any] = [StorageServiceEvents.photo : photo]
                    NotificationCenter.default.post(name: StorageServiceEvents.photoVoteDidUpdate, object: nil, userInfo: userInfo)
                }
            } catch {
                debugPrint(error)
            }
        }
    }

}
