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

    // Retrieve a stream
    func getStream(streamType : StreamType) -> StreamModel {
        if let stream = streamCache.objectForKey(streamType.rawValue) {
            return stream as! StreamModel
        } else {
            let stream = StreamModel(streamType: streamType)
            streamCache.setObject(stream, forKey: streamType.rawValue)
            return stream
        }
    }
    
    internal func streamPhotosDidReturn(notification : NSNotification) -> Void {
        let jsonData : NSData = notification.userInfo!["response"] as! NSData
        let streamType = StreamType(rawValue: notification.userInfo!["streamType"] as! String)
        if streamType == nil {
            debugPrint("Unrecognized stream type \(streamType)")
            return
        }

        dispatch_async(parsingQueue) { [weak self] in
            var newPhotos = [PhotoModel]()
            
            do {
                let jsonObject : AnyObject! = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions())
                let json = JSON(jsonObject)
                let page = json["current_page"].int!
                let totalCount = json["total_items"].int!
                
                for (_, photoJson):(String, JSON) in json["photos"] {
                    let photo = PhotoModel(json: photoJson)
                    newPhotos.append(photo)
                }
                
                self?.mergePhotosToStream(streamType!, photos: newPhotos, page: page, totalPhotos: totalCount)
            } catch {
                print(error)
            }
        }
    }
    
    private func mergePhotosToStream(streamType : StreamType, photos: [PhotoModel], page: Int, totalPhotos : Int) -> Void {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            let stream = self?.getStream(streamType)
            guard stream != nil else { return }
            stream!.totalCount = totalPhotos
            
            if(page == 1) {
                stream!.photos.removeAll()
            }
            
            stream!.photos += photos
            
            // Put the photos into cache
            for photo in photos {
                self?.photoCache.setObject(photo, forKey: photo.photoId)
            }
            
            let userInfo : [String : AnyObject] = [StorageServiceEvents.streamType : stream!.streamType.rawValue, StorageServiceEvents.page : page]
            NSNotificationCenter.defaultCenter().postNotificationName(StorageServiceEvents.streamDidUpdate, object: nil, userInfo: userInfo)
        }
    }
}
