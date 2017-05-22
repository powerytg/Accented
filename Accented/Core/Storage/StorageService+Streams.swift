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
    
    // Retrieve a photo search result stream with keyword
    func getStream(keyword : String) -> PhotoSearchStreamModel {
        let streamId = PhotoSearchStreamModel.streamIdWithKeyword(keyword)
        if let stream = streamCache.object(forKey: NSString(string: streamId)) {
            return stream as! PhotoSearchStreamModel
        } else {
            let stream = PhotoSearchStreamModel(keyword : keyword)
            streamCache.setObject(stream, forKey: NSString(string: streamId))
            return stream
        }
    }
    
    // Retrieve a photo search result stream with tag
    func getStream(tag : String) -> PhotoSearchStreamModel {
        let streamId = PhotoSearchStreamModel.streamIdWithTag(tag)
        if let stream = streamCache.object(forKey: NSString(string: streamId)) {
            return stream as! PhotoSearchStreamModel
        } else {
            let stream = PhotoSearchStreamModel(tag : tag)
            streamCache.setObject(stream, forKey: NSString(string: streamId))
            return stream
        }
    }
    
    internal func streamPhotosDidReturn(_ notification : Notification) -> Void {
        let jsonData : Data = notification.userInfo![RequestParameters.response] as! Data
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
                
                self?.mergePhotosToStream(notification.userInfo!, photos: newPhotos, page: page, totalPhotos: totalCount)
            } catch {
                print(error)
            }
        }
    }
    
    // This method is synchronized
    fileprivate func mergePhotosToStream(_ userInfo : [AnyHashable : Any], photos: [PhotoModel], page: Int, totalPhotos : Int) {
        // Validate results
        let streamTypeString = userInfo[RequestParameters.streamType] as? String
        let keyword = userInfo[RequestParameters.term] as? String
        let tag = userInfo[RequestParameters.tag] as? String
        
        var stream : StreamModel
        var streamType : StreamType?
        if streamTypeString != nil {
            streamType = StreamType(rawValue: streamTypeString!)
            if streamType == nil {
                debugPrint("Unrecognized stream type \(streamTypeString!))")
                return
            } else {
                stream = self.getStream(streamType!)
            }
        } else if keyword != nil {
            stream = getStream(keyword: keyword!)
        } else if tag != nil {
            stream = getStream(tag: tag!)
        } else {
            debugPrint("Stream does not have an identity))")
            return
        }
        
        synchronized(stream) {
            stream.totalCount = totalPhotos
            
            // Put the photos into cache
            for photo in photos {
                photoCache.setObject(photo, forKey: NSString(string: photo.photoId))
            }

            // If it's the first page and the new content is not strictly equal to the first page, then discard the entire stream
            if page == 1 && !isEqualCollection(newPhotos: photos, oldPhotos: stream.photos) {
                stream.photos = []
            }
            
            // Merge all in the new photos
            let mergedPhotos = mergeModelCollections(newModels: photos, withModels: stream.photos)
            stream.photos = mergedPhotos
            
            // Broadcast the stream update event
            DispatchQueue.main.async {
                let userInfo : [String : Any] = [StorageServiceEvents.streamId : stream.streamId,
                                                 StorageServiceEvents.page : page,
                                                 StorageServiceEvents.photos : mergedPhotos]
                NotificationCenter.default.post(name: StorageServiceEvents.streamDidUpdate, object: nil, userInfo: userInfo)
            }
        }
    }
}
