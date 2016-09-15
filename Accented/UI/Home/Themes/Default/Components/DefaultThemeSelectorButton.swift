//
//  GatewayPushButton.swift
//  Accented
//
//  Created by Tiangong You on 5/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DefaultThemeSelectorButton: PushButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderColor = ThemeManager.sharedInstance.currentTheme.pushButtonBorderColor.cgColor
        self.backgroundColor = ThemeManager.sharedInstance.currentTheme.pushButtonBackgroundColor
        self.setTitleColor(ThemeManager.sharedInstance.currentTheme.pushButtonTextColor, for: UIControlState())
    }
    
}
