//
//  UserStreamCardLayout.swift
//  Accented
//
//  User stream card layout
//
//  Created by Tiangong You on 8/24/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserStreamCardLayout: PhotoCardStreamLayout {

    override func generateLayoutAttributesForStreamHeader() {
        if fullWidth == 0 {
            fullWidth = UIScreen.main.bounds.width
        }
        
        // Stream header
        let indexPath = IndexPath(item : 0, section : 0)
        let headerCellSize = CGSize(width: fullWidth, height: UserStreamLayoutSpec.streamHeaderHeight)
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attrs.frame = CGRect(x: 0, y: 0, width: headerCellSize.width, height: headerCellSize.height)
        layoutCache["navHeader"] = attrs
        contentHeight = UserStreamLayoutSpec.streamHeaderHeight
    }
}
