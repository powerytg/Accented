//
//  StreamLayoutBase.swift
//  Accented
//
//  Created by Tiangong You on 4/28/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamLayoutBase: UICollectionViewFlowLayout {
    var photos : Array<PhotoModel> = []
    var leftMargin : CGFloat = 15
    var rightMargin : CGFloat = 15
    
    // Layout template generator that takes in a group of image sizes and returns calculated frames for the images
    var layoutGenerator : TemplateGenerator?
}
