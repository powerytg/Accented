//
//  PushButton.swift
//  Accented
//
//  Created by You, Tiangong on 5/4/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class PushButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    func initialize() {
        self.layer.borderColor = ThemeManager.sharedInstance.currentTheme.pushButtonBorderColor.cgColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = ThemeManager.sharedInstance.currentTheme.pushButtonBackgroundColor
        
        self.setTitleColor(ThemeManager.sharedInstance.currentTheme.pushButtonTextColor, for: .normal)
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
    }

}
