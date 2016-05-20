//
//  GatewayNavBlurView.swift
//  Accented
//
//  Created by Tiangong You on 5/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DefaultNavBlurView: BlurView {

    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.effect = ThemeManager.sharedInstance.currentTheme.backgroundBlurEffect
    }
    
}
