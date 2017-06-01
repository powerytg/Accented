//
//  DetailNavigationContext.swift
//  Accented
//
//  Created by Tiangong You on 8/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailNavigationContext: NSObject {
    
    var initialSelectedPhoto : PhotoModel
    var sourceImageView : UIImageView
    
    init(selectedPhoto : PhotoModel, sourceImageView : UIImageView) {
        self.initialSelectedPhoto = selectedPhoto
        self.sourceImageView = sourceImageView
        super.init()
    }
}
