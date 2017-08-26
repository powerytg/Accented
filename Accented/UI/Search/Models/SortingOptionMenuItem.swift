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
    var sortingOption : PhotoSearchSortingOptions
    
    init(_ sortingOption : PhotoSearchSortingOptions) {
        self.sortingOption = sortingOption
        super.init(TextUtils.sortOptionDisplayName(sortingOption))
    }
}
