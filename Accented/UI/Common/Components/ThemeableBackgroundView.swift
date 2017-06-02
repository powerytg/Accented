//
//  ThemeableBackgroundView.swift
//  Accented
//
//  Created by You, Tiangong on 5/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class ThemeableBackgroundView: UIView {

    var photo : PhotoModel? {
        didSet {
            photoDidChange()
        }
    }
    
    required init() {
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        self.backgroundColor = ThemeManager.sharedInstance.currentTheme.streamBackgroundColor
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(appThemeDidChange(_:)), name: ThemeManagerEvents.appThemeDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func photoDidChange() {
        
    }
    
    func appThemeDidChange(_ notification : Notification) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.applyThemeChangeAnimation()
        }) 
    }
    
    func applyThemeChangeAnimation() {
        self.backgroundColor = ThemeManager.sharedInstance.currentTheme.streamBackgroundColor
    }
    
    func performEntranceAnimation(_ completed: @escaping () -> Void) -> Void {
        // Not implemented in base class
    }
    
    func streamViewContentOffsetDidChange(_ contentOffset: CGFloat) -> Void {
        // Not implemented in base class
    }
}
