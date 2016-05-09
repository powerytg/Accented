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
    
    // Base background color
    var rootViewBackgroundColor : UIColor {
        return UIColor.blackColor()
    }
    
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

    // Footer text color
    var footerTextColor : UIColor {
        return UIColor(red: 203/255.0, green: 203/255.0, blue: 203/255.0, alpha: 1)
    }
    
    // Nav button normal color
    var navButtonNormalColor : UIColor {
        return UIColor(red: 202/255.0, green: 202/255.0, blue: 202/255.0, alpha: 1.0)
    }

    // Nav button selected color
    var navButtonSelectedColor : UIColor {
        return UIColor(red: 240/255.0, green: 33/255.0, blue: 101/255.0, alpha: 1.0)
    }

    // Nav bar border color
    var navBarBorderColor : UIColor {
        return UIColor(red: 162/255.0, green: 162/255.0, blue: 162/255.0, alpha: 1.0)
    }

    // Push button border color
    var pushButtonBorderColor : UIColor {
        return UIColor.whiteColor()
    }

    // Push button background color
    var pushButtonBackgroundColor : UIColor {
        return UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.1)
    }

    // Push button text color
    var pushButtonTextColor : UIColor {
        return UIColor.whiteColor()
    }

    var statusBarStyle : UIStatusBarStyle {
        return .LightContent
    }
    
    init(themeType : AppThemeType) {
        self.themeType = themeType
    }
}
