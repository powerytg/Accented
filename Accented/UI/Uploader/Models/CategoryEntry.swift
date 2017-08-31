//
//  CategoryEntry.swift
//  Accented
//
//  Created by You, Tiangong on 8/31/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class CategoryEntry: NSObject {
    var category : Category
    var title : String
    
    init(category : Category, title : String) {
        self.category = category
        self.title = title
        super.init()
    }
}
