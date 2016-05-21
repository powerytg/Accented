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
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        self.backgroundColor = ThemeManager.sharedInstance.currentTheme.streamBackgroundColor
        
        // Events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(appThemeDidChange(_:)), name: ThemeManagerEvents.appThemeDidChange, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func appThemeDidChange(notification : NSNotification) {
        UIView.animateWithDuration(0.3) { [weak self] in
            self?.applyThemeChangeAnimation()
        }
    }
    
    func applyThemeChangeAnimation() {
        self.backgroundColor = ThemeManager.sharedInstance.currentTheme.streamBackgroundColor
    }
    
    func performEntranceAnimation(completed: (() -> Void)) -> Void {
        // Not implemented in base class
    }
    
    func streamViewContentOffsetDidChange(contentOffset: CGFloat) -> Void {
        // Not implemented in base class
    }
}
