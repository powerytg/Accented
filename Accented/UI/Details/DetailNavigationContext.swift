//
//  DetailNavigationContext.swift
//  Accented
//
//  Created by Tiangong You on 8/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailNavigationContext: NSObject {
    
    var photoCollection = [PhotoModel]()
    var initialSelectedPhoto : PhotoModel
    var sourceImageView : UIImageView
    
    init(selectedPhoto : PhotoModel, photoCollection : [PhotoModel], sourceImageView : UIImageView) {
        self.initialSelectedPhoto = selectedPhoto
        self.photoCollection = photoCollection
        self.sourceImageView = sourceImageView
        super.init()
    }
}
