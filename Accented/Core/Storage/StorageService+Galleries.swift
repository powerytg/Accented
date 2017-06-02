//
//  StorageService+Galleries.swift
//  Accented
//
//  StorageService gallery extension
//
//  Created by You, Tiangong on 6/2/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import SwiftyJSON

extension StorageService {

    internal func galleryListDidReturn(_ notification : Notification) -> Void {
        let jsonData : Data = notification.userInfo![RequestParameters.response] as! Data
        parsingQueue.async { [weak self] in
            var newGalleries = [GalleryModel]()
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions())
                let json = JSON(jsonObject)
                let page = json["current_page"].int!
                let totalCount = json["total_items"].int!
                
                for (_, galleryJson):(String, JSON) in json["galleries"] {
                    let gallery = GalleryModel(json: galleryJson)
                    newGalleries.append(gallery)
                }
                
                self?.mergeGalleries(notification.userInfo!, galleries: newGalleries, page: page, totalCount: totalCount)
            } catch {
                debugPrint(error)
            }
        }
    }
    
    fileprivate func mergeGalleries(_ userInfo : [AnyHashable : Any], galleries: [GalleryModel], page: Int, totalCount : Int) {
        let userId = userInfo[RequestParameters.userId] as! String
        
        let collection = getUserGalleries(userId: userId)
        collection.totalCount = totalCount
        
        // If it's the first page and the new content is not strictly equal to the first page, then discard the entire stream
        if page == 1 && !isEqualCollection(newItems: galleries, oldItems: getFirstPage(collection.items)) {
            collection.items = []
        }
        
        // Merge all in the new photos
        let result = mergeModelCollections(newModels: galleries, withModels: collection.items)
        collection.items = result
        
        // Put the stream back to cache
        putUserGalleriesToCache(collection)
        
        // Broadcast the stream update event
        DispatchQueue.main.async {
            let userInfo : [String : Any] = [StorageServiceEvents.userId : userId,
                                             StorageServiceEvents.page : page,
                                             StorageServiceEvents.galleries : result]
            NotificationCenter.default.post(name: StorageServiceEvents.userGalleryListDidUpdate, object: nil, userInfo: userInfo)
        }
    }
}
