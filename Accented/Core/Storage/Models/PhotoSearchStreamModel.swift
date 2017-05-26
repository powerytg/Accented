//
//  PhotoSearchStreamModel.swift
//  Accented
//
//  Photo search result model
//
//  Created by Tiangong You on 5/21/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class PhotoSearchStreamModel: StreamModel {
    let sort : PhotoSearchSortingOptions
    var keyword : String?
    var tag : String?
    
    static func streamIdWithKeyword(keyword : String, sort : PhotoSearchSortingOptions) -> String {
        return "\(keyword)_\(sort.rawValue)"
    }

    static func streamIdWithTag(tag : String, sort : PhotoSearchSortingOptions) -> String {
        return "\(tag)_\(sort.rawValue)"
    }

    override var streamId: String {
        if keyword != nil {
            return PhotoSearchStreamModel.streamIdWithKeyword(keyword : keyword!, sort: sort)
        } else if tag != nil {
            return PhotoSearchStreamModel.streamIdWithTag(tag : tag!, sort : sort)
        } else {
            fatalError("Neither tag nor keyword is present")
        }
    }
    
    init(keyword : String, sort : PhotoSearchSortingOptions) {
        self.keyword = keyword
        self.sort = sort
        super.init(streamType: .Search)
    }
    
    init(tag : String, sort : PhotoSearchSortingOptions) {
        self.tag = tag
        self.sort = sort
        super.init(streamType: .Search)
    }

    override func copy(with zone: NSZone? = nil) -> Any {
        var clone : PhotoSearchStreamModel
        if keyword != nil {
            clone = PhotoSearchStreamModel(keyword : self.keyword!, sort : sort)
        } else if tag != nil {
            clone = PhotoSearchStreamModel(tag : self.tag!, sort : sort)
        } else {
            fatalError("Neither tag nor keyword is present")
        }
        
        clone.totalCount = self.totalCount
        clone.items = items
        return clone
    }
}
