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
            streamCache.setObject(stream, forKey: streamType.rawValue)
            return stream
        }
    }
    
    func streamPhotosDidReturn(notification : NSNotification) -> Void {
        let jsonData : NSData = notification.userInfo!["response"] as! NSData
        let page : Int = notification.userInfo!["page"] as! Int
        let streamType = StreamType(rawValue: notification.userInfo!["streamType"] as! String)
        let stream = getStream(streamType!)
        
        dispatch_async(parsingQueue) { [weak self] in
            var newPhotos = [PhotoModel]()
            
            do {
                let jsonObject : AnyObject! = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions())
                let json = JSON(jsonObject)
                let streamType = json["feature"].string
                let page = json["current_page"].int
                let totalPageCount = json["total_pages"].int
                
                for (index, photoJson):(String, JSON) in json["photos"] {
                    let photo = PhotoModel(json: photoJson)
                    newPhotos.append(photo)
                }
                
                self?.mergePhotosToStream(stream, photos: newPhotos, page: page!)
            } catch {
                print(error)
            }
        }
    }
    
    func mergePhotosToStream(stream : StreamModel, photos: [PhotoModel], page: Int) -> Void {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            if(page == 1) {
                stream.photos.removeAll()
            }
            
            stream.photos += photos
            
            let userInfo : [String : AnyObject] = [StorageServiceEvents.streamType : stream.streamType.rawValue, StorageServiceEvents.page : page]
            NSNotificationCenter.defaultCenter().postNotificationName(StorageServiceEvents.streamDidUpdate, object: nil, userInfo: userInfo)
        }
    }
}
