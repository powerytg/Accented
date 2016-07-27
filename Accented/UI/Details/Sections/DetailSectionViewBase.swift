//
//  DetailSectionViewBase.swift
//  Accented
//
//  Created by You, Tiangong on 7/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailSectionViewBase: UIView, DetailEntranceAnimation {

    var photo : PhotoModel
    var maxWidth : CGFloat
    
    init(photo : PhotoModel, maxWidth : CGFloat) {
        self.photo = photo
        self.maxWidth = maxWidth
        super.init(frame : CGRectZero)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        // Not implemented in base class
    }
    
    func estimatedHeight(width : CGFloat) -> CGFloat {
        fatalError("init(coder:) has not been implemented")
    }
    
    func entranceAnimationWillBegin() {
        // Not implemented in the base class
    }
    
    func performEntranceAnimation() {
        // Not implemented in the base class
    }
    
    func entranceAnimationDidFinish() {
        // Not implemented in the base class
    }
    
}
