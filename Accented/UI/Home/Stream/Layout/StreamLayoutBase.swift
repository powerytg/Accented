//
//  StreamLayoutBase.swift
//  Accented
//
//  Created by Tiangong You on 4/28/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol StreamLayoutDelegate : NSObjectProtocol {
    func streamHeaderCompressionRatioDidChange(_ headerCompressionRatio : CGFloat)
}

class StreamLayoutBase: InfiniteLoadingLayout<PhotoModel> {
    
    var leftMargin : CGFloat {
        return 15
    }
    
    var rightMargin : CGFloat {
        return 15
    }
    
    var fullWidth : CGFloat = 0
    var availableWidth : CGFloat {
        return fullWidth - leftMargin - rightMargin
    }
    
    weak var delegate : StreamLayoutDelegate?
    
    // Range is 0...1, where 0 indicates the header is not sticky, where 1 indicates the header is fully sticky
    var headerCompressionRatio : CGFloat = 0

    weak var layoutDelegate : UICollectionViewDelegateFlowLayout?
    
    func generateLayoutAttributesForTemplates(_ templates : [StreamLayoutTemplate], sectionStartIndex : Int) -> Void {
        fatalError("Not implemented in base class")
    }

    func generateLayoutAttributesForStreamHeader() {
        fatalError("Not implemented in base class")
    }
}
