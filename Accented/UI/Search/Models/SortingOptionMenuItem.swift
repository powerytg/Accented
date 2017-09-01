//
//  SortingOptionMenuItem.swift
//  Accented
//
//  Sorting options menu item
//
//  Created by You, Tiangong on 8/26/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class SortingOptionMenuItem: MenuItem {
    var option : PhotoSearchSortingOptions
    
    init(option : PhotoSearchSortingOptions, text: String) {
        self.option = option
        super.init(TextUtils.sortOptionDisplayName(option))
    }
}
