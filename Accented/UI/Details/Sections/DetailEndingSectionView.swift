//
//  DetailEndingSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/7/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailEndingSectionView: DetailSectionViewBase {

    override var sectionId: String {
        return "ending"
    }

    // Fixed content size
    fileprivate let contentHeight : CGFloat = 80
    
    override func calculatedHeightForPhoto(_ photo: PhotoModel, width: CGFloat) -> CGFloat {
        return contentHeight
    }
}
