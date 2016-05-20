//
//  ThemeableBackgroundView.swift
//  Accented
//
//  Created by You, Tiangong on 5/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class ThemeableBackgroundView: UIView {

    var photo : PhotoModel?
    
    required init() {
        super.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func performEntranceAnimation(completed: (() -> Void)) -> Void {
        // Not implemented in base class
    }
    
    func streamViewContentOffsetDidChange(contentOffset: CGFloat) -> Void {
        // Not implemented in base class
    }
}
