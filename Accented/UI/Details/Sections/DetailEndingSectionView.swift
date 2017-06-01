//
//  DetailEndingSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/7/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailEndingSectionView: DetailSectionViewBase {

    // Fixed content size
    fileprivate let contentHeight : CGFloat = 80
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        return contentHeight
    }
}
