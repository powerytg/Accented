//
//  AppTheme.swift
//  Accented
//
//  Created by You, Tiangong on 5/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

enum AppThemeType {
    case Light
    case Dark
}

class AppTheme: NSObject {
    
    var themeType : AppThemeType
    
    // Background blur effect
    var backgroundBlurEffect : UIBlurEffect {
        return UIBlurEffect(style: .Dark)
    }
    
    // Whether the background requires desaturated image
    var shouldUseDesaturatedBackground : Bool {
        return true
    }
    
    // Title text color
    var titleTextColor : UIColor {
        return UIColor.whiteColor()
    }

    // Standard text color
    var standardTextColor : UIColor {
        return UIColor.whiteColor()
    }

    var statusBarStyle : UIStatusBarStyle {
        return .LightContent
    }
    
    init(themeType : AppThemeType) {
        self.themeType = themeType
    }
}
