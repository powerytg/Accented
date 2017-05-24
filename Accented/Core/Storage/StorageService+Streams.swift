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
                debugPrint(error)
            }
        }
    }
    
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
            stream = self.getPhotoSearchResult(keyword: keyword!)
        } else if tag != nil {
            stream = getPhotoSearchResult(tag: tag!)
        } else {
            debugPrint("Stream does not have an identity))")
            return
        }
        
        stream.totalCount = totalPhotos
        
        // If it's the first page and the new content is not strictly equal to the first page, then discard the entire stream
        if page == 1 && !isEqualCollection(newItems: photos, oldItems: stream.items) {
            stream.items = []
        }
        
        // Merge all in the new photos
        let mergedPhotos = mergeModelCollections(newModels: photos, withModels: stream.items)
        stream.items = mergedPhotos
        
        // Put the stream back to cache
        if stream is PhotoSearchStreamModel {
            putPhotoSearchResultToCache(stream as! PhotoSearchStreamModel)
        } else {
            putStreamToCache(stream)
        }
        
        // Broadcast the stream update event
        DispatchQueue.main.async {
            let userInfo : [String : Any] = [StorageServiceEvents.streamId : stream.streamId,
                                             StorageServiceEvents.page : page,
                                             StorageServiceEvents.photos : mergedPhotos]
            NotificationCenter.default.post(name: StorageServiceEvents.streamDidUpdate, object: nil, userInfo: userInfo)
        }
    }
}
