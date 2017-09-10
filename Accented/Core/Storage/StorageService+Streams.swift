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
    
    private func mergePhotosToStream(_ userInfo : [AnyHashable : Any], photos: [PhotoModel], page: Int, totalPhotos : Int) {
        // Validate results
        guard let streamTypeString = userInfo[RequestParameters.feature] as? String else {
            debugPrint("Stream does not have an identity")
            return
        }
        
        guard let streamType = StreamType(rawValue: streamTypeString) else {
            debugPrint("Unrecognized stream type \(streamTypeString))")
            return
        }
        
        let keyword = userInfo[RequestParameters.term] as? String
        let tag = userInfo[RequestParameters.tag] as? String
        let sort = userInfo[RequestParameters.sort] as? PhotoSearchSortingOptions
        let userId = userInfo[RequestParameters.userId] as? String
        let galleryId = userInfo[RequestParameters.galleryId] as? String
        
        var stream : StreamModel!
        switch streamType {
        case .Search:
            if keyword != nil {
                stream = getPhotoSearchResult(keyword: keyword!, sort : sort!)
            } else if tag != nil {
                stream = getPhotoSearchResult(tag: tag!, sort : sort!)
            }
        case .User:
            stream = getUserStream(userId: userId!)
        case .Gallery:
            if userId != nil && galleryId != nil {
                stream = getGalleryPhotoStream(userId: userId!, galleryId: galleryId!)
            }
        default:
            stream = self.getStream(streamType)
        }
        
        stream.totalCount = totalPhotos
        
        // If it's the first page and the new content is not strictly equal to the first page, then discard the entire stream
        if page == 1 && !isEqualCollection(newItems: photos, oldItems: getFirstPage(stream.items)) {
            stream.items = []
        }
        
        // Merge all in the new photos
        let mergedPhotos = mergeModelCollections(newModels: photos, withModels: stream.items)
        stream.items = mergedPhotos
        
        // Put the stream back to cache
        if stream is PhotoSearchStreamModel {
            putPhotoSearchResultToCache(stream as! PhotoSearchStreamModel)
        } else if stream is UserStreamModel {
            putUserStreamToCache(stream as! UserStreamModel)
        } else if stream is GalleryStreamModel {
            putGalleryStreamToCache(stream as! GalleryStreamModel)
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
