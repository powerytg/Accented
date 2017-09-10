//
//  CategoryEntry.swift
//  Accented
//
//  Created by You, Tiangong on 8/31/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class CategoryEntry: MenuItem {
    var category : Category
    
    init(category : Category, text : String) {
        self.category = category
        super.init(action: .None, text: text)
    }
}
