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
        let jsonData : Data = (notification as NSNotification).userInfo!["response"] as! Data
        let photoId = (notification as NSNotification).userInfo!["photoId"] as! String;
        
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
                print(error)
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
            
            photo!.comments += comments
            
            let userInfo : [String : AnyObject] = [StorageServiceEvents.photoId : photoId as AnyObject, StorageServiceEvents.page : page as AnyObject]
            NotificationCenter.default.post(name: StorageServiceEvents.photoCommentsDidUpdate, object: nil, userInfo: userInfo)
        }
    }
    
}
