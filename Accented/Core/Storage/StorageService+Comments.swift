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
                    let comment = CommentModel(json: commentJSON)
                    newComments.append(comment)
                }
                
                self?.mergeCommentsToPhoto(photoId, comments: newComments, page: page, commentsCount : commentsCount)
            } catch {
                debugPrint(error)
            }
        }
    }
    
    fileprivate func mergeCommentsToPhoto(_ photoId : String, comments: [CommentModel], page: Int, commentsCount : Int) -> Void {
        DispatchQueue.main.async { [weak self] in
            let photo = self?.photoCache.object(forKey: NSString(string : photoId))
            guard photo != nil else { return }
            photo!.commentsCount = commentsCount
            
            if(page == 1) {
                photo!.comments.removeAll()
            }
            
            // Find if the new comments already exist in the photo. If so, replace the old entries with the new ones
            var existingCommentIds = [String : CommentModel]()
            for comment in photo!.comments {
                existingCommentIds[comment.commentId] = comment
            }
            
            for comment in comments {
                if let oldComment = existingCommentIds[comment.commentId] {
                    photo!.comments.remove(at: photo!.comments.index(of: oldComment)!)
                }
            }
            
            photo!.comments += comments
            
            let userInfo : [String : AnyObject] = [StorageServiceEvents.photoId : photoId as AnyObject, StorageServiceEvents.page : page as AnyObject]
            NotificationCenter.default.post(name: StorageServiceEvents.photoCommentsDidUpdate, object: nil, userInfo: userInfo)
        }
    }
    
    internal func didPostComment(_ notification : Notification) {
        let jsonData : Data = (notification as NSNotification).userInfo![RequestParameters.response] as! Data
        let photoId = (notification as NSNotification).userInfo![RequestParameters.photoId] as! String;
        let photo = photoCache.object(forKey: NSString(string : photoId))
        guard photo != nil else { return }

        parsingQueue.async {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions())
                let json = JSON(jsonObject)
                let commentJson = json["comment"]
                let comment = CommentModel(json: commentJson)
                
                // Append the comment to the rear of photo's comment list
                if photo!.commentsCount != nil {
                    photo!.commentsCount! += 1
                } else {
                    photo!.commentsCount = 1
                }
                
                photo!.comments.append(comment)
                
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
