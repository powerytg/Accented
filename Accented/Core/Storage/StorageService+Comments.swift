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

    internal func photoCommentsDidReturn(notification : NSNotification) -> Void {
        // NOTE: NSCache is thread safe
        let jsonData : NSData = notification.userInfo!["response"] as! NSData
        let photoId = notification.userInfo!["photoId"] as! String;
        
        dispatch_async(parsingQueue) { [weak self] in
            var newComments = [CommentModel]()
            
            do {
                let jsonObject : AnyObject! = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions())
                let json = JSON(jsonObject)
                let page = json["current_page"].int!
                let commentsCount = json["total_items"].int!
                
                for (_, commentJSON):(String, JSON) in json["comments"] {
                    let comment = CommentModel(json: commentJSON)
                    newComments.append(comment)
                }
                
                self?.mergeCommentsToPhoto(photoId, comments: newComments, page: page, commentsCount : commentsCount)
            } catch {
                print(error)
            }
        }
    }
    
    private func mergeCommentsToPhoto(photoId : String, comments: [CommentModel], page: Int, commentsCount : Int) -> Void {
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            let photo = self?.photoCache.objectForKey(photoId) as? PhotoModel
            guard photo != nil else { return }
            photo!.commentsCount = commentsCount
            
            if(page == 1) {
                photo!.comments.removeAll()
            }
            
            photo!.comments += comments
            
            let userInfo : [String : AnyObject] = [StorageServiceEvents.photoId : photoId, StorageServiceEvents.page : page]
            NSNotificationCenter.defaultCenter().postNotificationName(StorageServiceEvents.photoCommentsDidUpdate, object: nil, userInfo: userInfo)
        }
    }
    
}
