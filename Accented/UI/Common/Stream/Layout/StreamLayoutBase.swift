//
//  StreamLayoutBase.swift
//  Accented
//
//  Created by Tiangong You on 4/28/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamLayoutBase: UICollectionViewFlowLayout {
    
    var leftMargin : CGFloat = 15
    var rightMargin : CGFloat = 15
    
    var contentHeight : CGFloat = 0
    var availableWidth : CGFloat = 0
    
    weak var layoutDelegate : UICollectionViewDelegateFlowLayout?
    
    // A cache that holds all the previously calculated layout attributes. The cache will remain valid until
    // explicitly cleared
    var layoutCache : Array<UICollectionViewLayoutAttributes> = []

    func clearLayoutCache() {
        contentHeight = 0
        layoutCache.removeAll()
    }
    
    func generateLayoutAttributesForLoadingState() {
        fatalError("Not implemented in base class")
    }
    
    func generateLayoutAttributesForTemplates(templates : [StreamLayoutTemplate], sectionStartIndex : Int) -> Void {
        fatalError("Not implemented in base class")
    }
    
}
