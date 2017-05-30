//
//  AppTheme.swift
//  Accented
//
//  Created by You, Tiangong on 5/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

enum AppThemeType {
    case light
    case dark
    case journalDark
    case journalLight
}

class AppTheme: NSObject {
    
    var themeType : AppThemeType
    
    // Display label
    var displayLabel : String {
        return "default"
    }
    
    var displayThumbnail : UIImage! {
        return UIImage(named: "DarkThemeThumbnail")
    }
    
    // Base background color
    var rootViewBackgroundColor : UIColor {
        return UIColor.black
    }

    // Home stream background color
    var streamBackgroundColor : UIColor {
        return UIColor.black
    }

    // Background blur effect
    var backgroundBlurEffect : UIBlurEffect {
        return UIBlurEffect(style: .dark)
    }
    
    // Whether the background requires desaturated image
    var shouldUseDesaturatedBackground : Bool {
        return true
    }
    
    // Title text color
    var titleTextColor : UIColor {
        return UIColor.white
    }

    // Standard text color
    var standardTextColor : UIColor {
        return UIColor.white
    }

    // Description text color
    var descTextColor : UIColor {
        return UIColor(red: 203/255.0, green: 203/255.0, blue: 203/255.0, alpha: 1)
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
        return UIColor.white
    }

    // Push button background color
    var pushButtonBackgroundColor : UIColor {
        return UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.1)
    }

    // Push button text color
    var pushButtonTextColor : UIColor {
        return UIColor.white
    }

    // Navigation button font
    var navButtonFont : UIFont {
        return UIFont(name: "AvenirNextCondensed-DemiBold", size: 15)!
    }
    
    // Navigation content left margin
    var navContentLeftPadding : CGFloat {
        return 15
    }

    // Navigation content top margin
    var navContentTopPadding : CGFloat {
        return 30
    }

    // Custom navigation bar height
    var navBarHeight : CGFloat {
        return 80
    }
    
    var statusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // Background view type
    var backgroundViewClass : ThemeableBackgroundView.Type {
        return BlurredBackbroundView.self
    }
    
    // Stream view model
    var streamViewModelClass : StreamViewModel.Type {
        return DefaultViewModel.self
    }
    
    // Selected card title font
    var selectedCardNavFont : UIFont {
        return UIFont(name: "AvenirNextCondensed-DemiBold", size: 17)!
    }

    // Normal card title font
    var normalCardNavFont : UIFont {
        return UIFont(name: "AvenirNextCondensed-Medium", size: 17)!
    }

    // Link color
    var linkColor : UIColor {
        return UIColor(red: 92 / 255.0, green: 125 / 255.0, blue: 161 / 255.0, alpha: 1)
    }
    
    // Link highlight color
    var linkHighlightColor : UIColor {
        return UIColor.white
    }

    init(themeType : AppThemeType) {
        self.themeType = themeType
    }
}
