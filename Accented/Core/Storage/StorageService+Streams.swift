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
    func getStream(_ streamType : StreamType) -> StreamModel {
        if let stream = streamCache.object(forKey: NSString(string: streamType.rawValue)) {
            return stream
        } else {
            let stream = StreamModel(streamType: streamType)
            streamCache.setObject(stream, forKey: NSString(string: streamType.rawValue))
            return stream
        }
    }
    
    internal func streamPhotosDidReturn(_ notification : Notification) -> Void {
        let jsonData : Data = (notification as NSNotification).userInfo!["response"] as! Data
        let streamType = StreamType(rawValue: (notification as NSNotification).userInfo!["streamType"] as! String)
        if streamType == nil {
            debugPrint("Unrecognized stream type \(String(describing: streamType))")
            return
        }

        parsingQueue.async { [weak self] in
            var newPhotos = [PhotoModel]()
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions())
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
    
    fileprivate func mergePhotosToStream(_ streamType : StreamType, photos: [PhotoModel], page: Int, totalPhotos : Int) -> Void {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            let stream = self?.getStream(streamType)
            guard stream != nil else { return }
            stream!.totalCount = totalPhotos
            
            if page == 1 && strongSelf.hasOverlapContent(newPhotos: photos, oldPhotos: stream!.photos) {
                stream!.photos.removeAll()
            }
            
            stream!.photos += photos
            
            // Put the photos into cache
            for photo in photos {
                self?.photoCache.setObject(photo, forKey: NSString(string: photo.photoId))
            }
            
            let userInfo : [String : AnyObject] = [StorageServiceEvents.streamType : stream!.streamType.rawValue as AnyObject, StorageServiceEvents.page : page as AnyObject]
            NotificationCenter.default.post(name: StorageServiceEvents.streamDidUpdate, object: nil, userInfo: userInfo)
        }
    }
    
    fileprivate func hasOverlapContent(newPhotos : [PhotoModel], oldPhotos : [PhotoModel]) -> Bool {
        if newPhotos.count == 0 {
            return false
        }
        
        if oldPhotos.count == 0 {
            return true
        }
        
        if oldPhotos.contains(newPhotos.last!) {
            return true
        } else {
            return false
        }
    }
    
}
