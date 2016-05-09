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
        
        if ThemeManager.sharedInstance.currentTheme.themeType == .Light {
            self.layer.borderColor = UIColor(red: 100 / 255.0, green: 100 / 255.0, blue: 100 / 255.0, alpha: 1).CGColor
            self.backgroundColor = UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 0.9)
            self.setTitleColor(UIColor(red: 76 / 255.0, green: 76 / 255.0, blue: 76 / 255.0, alpha: 1), forState: .Normal)
            
        } else {
            self.layer.borderColor = UIColor.whiteColor().CGColor
            self.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.1)
            self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
    }
    
}
