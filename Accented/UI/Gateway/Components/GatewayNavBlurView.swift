//
//  GatewayNavBlurView.swift
//  Accented
//
//  Created by Tiangong You on 5/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class GatewayNavBlurView: BlurView {

    override func initialize() {
        super.initialize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if ThemeManager.sharedInstance.currentTheme.themeType == .Light {
            blurView.effect = UIBlurEffect(style: .ExtraLight)
        } else {
            blurView.effect = UIBlurEffect(style: .Dark)
        }

    }
    
}
