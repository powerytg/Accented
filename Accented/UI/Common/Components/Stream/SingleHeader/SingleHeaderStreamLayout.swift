//
//  SingleHeaderStreamLayout.swift
//  Accented
//
//  Created by Tiangong You on 8/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class SingleHeaderStreamLayout: PhotoGroupStreamLayout {
    var headerHeight : CGFloat
    
    init(headerHeight : CGFloat) {
        self.headerHeight = headerHeight
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func generateLayoutAttributesForStreamHeader() {
        if fullWidth == 0 {
            fullWidth = UIScreen.main.bounds.width
        }
        
        // Stream header
        let indexPath = IndexPath(item : 0, section : 0)
        let headerCellSize = CGSize(width: fullWidth, height: headerHeight)
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attrs.frame = CGRect(x: 0, y: 0, width: headerCellSize.width, height: headerCellSize.height)
        layoutCache["streamHeader"] = attrs
        contentHeight = headerHeight
    }
}
