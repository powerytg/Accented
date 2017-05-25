//
//  StorageService+Comments.swift
//  Accented
//
//  Created by You, Tiangong on 8/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import SwiftyJSON

extension StorageService {

    internal func photoCommentsDidReturn(_ notification : Notification) -> Void {
        // NOTE: NSCache is thread safe
        let jsonData : Data = (notification as NSNotification).userInfo![RequestParameters.response] as! Data
        let photoId = (notification as NSNotification).userInfo![RequestParameters.photoId] as! String;
        
        parsingQueue.async { [weak self] in
            var newComments = [CommentModel]()
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions())
                let json = JSON(jsonObject)
                let page = json["current_page"].int!
                let commentsCount = json["total_items"].int!
                
                for (_, commentJSON):(String, JSON) in json["comments"] {
                    if commentJSON["parent_id"].string != nil {
                        newComments.append(ReplyModel(json : commentJSON))
                    } else {
                        newComments.append(CommentModel(json : commentJSON))
                    }
                }
                
                self?.mergeCommentsToPhoto(photoId, comments: newComments, page: page, commentsCount : commentsCount)
            } catch {
                debugPrint(error)
            }
        }
    }
    
    fileprivate func mergeCommentsToPhoto(_ photoId : String, comments: [CommentModel], page: Int, commentsCount : Int) -> Void {
        let collection = getComments(photoId)
        collection.totalCount = commentsCount
        
        // If it's the first page and the new content is not strictly equal to the first page, then discard the entire stream
        if page == 1 && !isEqualCollection(newItems: comments, oldItems: getFirstPage(collection.items)) {
            collection.items = []
        }
        
        // Merge all in the new photos
        let mergedComments = mergeModelCollections(newModels: comments, withModels: collection.items)
        collection.items = mergedComments
        
        // Put the stream back to cache
        putCommentsToCache(collection)
        
        DispatchQueue.main.async {
            let userInfo : [String : AnyObject] = [StorageServiceEvents.photoId : photoId as AnyObject,
                                                   StorageServiceEvents.page : page as AnyObject]
            NotificationCenter.default.post(name: StorageServiceEvents.photoCommentsDidUpdate, object: nil, userInfo: userInfo)
        }
    }
    
    internal func didPostComment(_ notification : Notification) {
        let jsonData : Data = (notification as NSNotification).userInfo![RequestParameters.response] as! Data
        let photoId = (notification as NSNotification).userInfo![RequestParameters.photoId] as! String;
        let collection = getComments(photoId)

        parsingQueue.async {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions())
                let json = JSON(jsonObject)
                let commentJson = json["comment"]
                let comment = CommentModel(json: commentJson)
                
                // Append the comment to the rear of photo's comment list
                if collection.totalCount != nil {
                    collection.totalCount! += 1
                } else {
                    collection.totalCount = 1
                }
                
                collection.items.append(comment)
                
                // Put the stream back to cache
                self.putCommentsToCache(collection)

                DispatchQueue.main.async {
                    let userInfo : [String : AnyObject] = [StorageServiceEvents.photoId : photoId as AnyObject]
                    NotificationCenter.default.post(name: StorageServiceEvents.didPostComment, object: nil, userInfo: userInfo)
                }
            } catch {
                debugPrint(error)
            }
        }
    }
}
