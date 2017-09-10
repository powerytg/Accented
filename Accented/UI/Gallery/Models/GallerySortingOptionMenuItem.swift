//
//  GallerySortingOptionMenuItem.swift
//  Accented
//
//  Created by Tiangong You on 9/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class GallerySortingOptionMenuItem: MenuItem {
    var option : GalleryStreamSortingOptions
    
    init(option : GalleryStreamSortingOptions, text: String) {
        self.option = option
        super.init(action: .None, text: TextUtils.gallerySortOptionDisplayName(option))
    }
}
