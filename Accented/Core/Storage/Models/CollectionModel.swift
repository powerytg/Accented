//
//  CollectionModel.swift
//  Accented
//
//  Model that represents a continuously loadable collection of data
//
//  Created by Tiangong You on 5/23/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class CollectionModel<T : ModelBase> : ModelBase {
    // Total count of items. If nil, then it indicates that the collection has not been loaded
    var totalCount : Int?
    
    // Collection of items
    var items = [T]()
    
    // Whether the collection been loaded
    var loaded : Bool {
        return totalCount != nil
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        fatalError("Not implemented in base")
    }
}
