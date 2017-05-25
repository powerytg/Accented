//
//  StorageService+Users.swift
//  Accented
//
//  Created by Tiangong You on 5/24/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import SwiftyJSON

extension StorageService {
    internal func userSearchDidReturn(_ notification : Notification) -> Void {
        let jsonData : Data = (notification as NSNotification).userInfo![RequestParameters.response] as! Data
        let keyword = (notification as NSNotification).userInfo![RequestParameters.term] as! String;
        
        parsingQueue.async { [weak self] in
            var newUsers = [UserModel]()
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions())
                let json = JSON(jsonObject)
                let page = json["current_page"].int!
                let totalCount = json["total_items"].int!
                
                for (_, userJSON):(String, JSON) in json["users"] {
                    newUsers.append(UserModel(json: userJSON))
                }
                
                self?.mergeUserSearchResult(keyword, users: newUsers, page: page, totalCount : totalCount)
            } catch {
                debugPrint(error)
            }
        }
    }
    
    fileprivate func mergeUserSearchResult(_ keyword : String, users: [UserModel], page: Int, totalCount : Int) -> Void {
        let collection = getUserSearchResult(keyword: keyword)
        collection.totalCount = totalCount
        
        // If it's the first page and the new content is not strictly equal to the first page, then discard the entire stream
        if page == 1 && !isEqualCollection(newItems: users, oldItems: getFirstPage(collection.items)) {
            collection.items = []
        }
        
        // Merge collecton
        let result = mergeModelCollections(newModels: users, withModels: collection.items)
        collection.items = result
        
        // Put the stream back to cache
        putUserSearchResultToCache(collection)
        
        DispatchQueue.main.async {
            let userInfo : [String : AnyObject] = [StorageServiceEvents.keyword : keyword as AnyObject,
                                                   StorageServiceEvents.page : page as AnyObject]
            NotificationCenter.default.post(name: StorageServiceEvents.userSearchResultDidUpdate, object: nil, userInfo: userInfo)
        }
    }
}
