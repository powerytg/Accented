//
//  LightTheme.swift
//  Accented
//
//  Created by You, Tiangong on 5/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class LightTheme: AppTheme {
    
    override var backgroundBlurEffect : UIBlurEffect {
        return UIBlurEffect(style: .ExtraLight)
    }
    
    override var shouldUseDesaturatedBackground : Bool {
        return false
    }

    override var titleTextColor : UIColor {
        return UIColor(red: 80 / 255.0, green: 80 / 255.0, blue: 80 / 255.0, alpha: 1.0)
    }

    override var standardTextColor : UIColor {
        return UIColor(red: 60 / 255.0, green: 60 / 255.0, blue: 60 / 255.0, alpha: 1.0)
    }
    
    override var statusBarStyle : UIStatusBarStyle {
        return .Default
    }

    init() {
        super.init(themeType: .Light)
    }
    
}
