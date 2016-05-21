//
//  StreamLayoutBase.swift
//  Accented
//
//  Created by Tiangong You on 4/28/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit


protocol StreamLayoutDelegate : NSObjectProtocol {
    func streamHeaderCompressionRatioDidChange(headerCompressionRatio : CGFloat)
}

class StreamLayoutBase: UICollectionViewFlowLayout {
    
    var leftMargin : CGFloat {
        return 15
    }
    
    var rightMargin : CGFloat {
        return 15
    }
    
    var contentHeight : CGFloat = 0
    var fullWidth : CGFloat = 0
    var availableWidth : CGFloat {
        return fullWidth - leftMargin - rightMargin
    }
    
    weak var delegate : StreamLayoutDelegate?
    
    // Range is 0...1, where 0 indicates the header is not sticky, where 1 indicates the header is fully sticky
    var headerCompressionRatio : CGFloat = 0

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

    func generateLayoutAttributesForStreamHeader() {
        fatalError("Not implemented in base class")
    }
}
