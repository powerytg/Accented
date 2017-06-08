//
//  RefreshHeaderView.swift
//  Accented
//
//  Created by You, Tiangong on 10/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class RefreshHeaderView: UIView {

    static let maxHeight : CGFloat = 4
    static let maxTravelDistance : CGFloat = 60
    
    init() {
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = ThemeManager.sharedInstance.currentTheme.navButtonSelectedColor
        self.layer.cornerRadius = 2
    }
    
}
