//
//  UserStreamLayout.swift
//  Accented
//
//  Created by Tiangong You on 8/23/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserStreamLayout: PhotoGroupStreamLayout {

    private let streamHeaderHeight : CGFloat = 200
    
    override func generateLayoutAttributesForStreamHeader() {
        if fullWidth == 0 {
            fullWidth = UIScreen.main.bounds.width
        }
        
        // Stream header
        let indexPath = IndexPath(item : 0, section : 0)
        let headerCellSize = CGSize(width: fullWidth, height: streamHeaderHeight)
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attrs.frame = CGRect(x: 0, y: 0, width: headerCellSize.width, height: headerCellSize.height)
        layoutCache["navHeader"] = attrs
        contentHeight = streamHeaderHeight
    }
    
}
