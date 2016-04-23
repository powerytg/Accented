//
//  StorageService+Streams.swift
//  Accented
//
//  Created by You, Tiangong on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import SwiftyJSON

extension StorageService {

    func getStream(streamType : StreamType) -> StreamModel {
        if let stream = streamCache.objectForKey(streamType.rawValue) {
            return stream as! StreamModel
        } else {
            let stream = StreamModel(streamType: streamType)
            streamCache.setValue(stream, forKey: streamType.rawValue)
            return stream
        }
    }
    
    func streamPhotosDidReturn(notification : NSNotification) -> Void {
        let jsonData : NSData = notification.userInfo!["response"] as! NSData
        
        dispatch_async(parsingQueue) {
            do {
                let jsonObject : AnyObject! = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions())
                let json = JSON(jsonObject)
                let streamType = json["feature"].string
                let page = json["current_page"].int
                let totalPageCount = json["total_pages"].int
                
                for (index, photoJson):(String, JSON) in json["photos"] {
                    //Do something you want
                    print("photo")
                    print(photoJson)
                }
                
                print(json)
            } catch {
                print(error)
                print(String(data: jsonData, encoding: NSUTF8StringEncoding))
            }
        }
    }
}
