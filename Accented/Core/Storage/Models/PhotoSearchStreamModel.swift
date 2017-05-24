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

    var keyword : String?
    var tag : String?
    
    static func streamIdWithKeyword(_ keyword : String) -> String {
        return keyword
    }

    static func streamIdWithTag(_ tag : String) -> String {
        return tag
    }

    override var streamId: String {
        if keyword != nil {
            return PhotoSearchStreamModel.streamIdWithKeyword(keyword!)
        } else if tag != nil {
            return PhotoSearchStreamModel.streamIdWithKeyword(tag!)
        } else {
            fatalError("Neither tag nor keyword is present")
        }
    }
    
    init(keyword : String) {
        self.keyword = keyword
        super.init(streamType: .Search)
    }
    
    init(tag : String) {
        self.tag = tag
        super.init(streamType: .Search)
    }

    override func copy(with zone: NSZone? = nil) -> Any {
        var clone : PhotoSearchStreamModel
        if keyword != nil {
            clone = PhotoSearchStreamModel(keyword : self.keyword!)
        } else if tag != nil {
            clone = PhotoSearchStreamModel(tag : self.tag!)
        } else {
            fatalError("Neither tag nor keyword is present")
        }
        
        clone.totalCount = self.totalCount
        clone.items = items
        return clone
    }
}
