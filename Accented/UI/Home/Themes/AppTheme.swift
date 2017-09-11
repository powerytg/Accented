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
    
    var backgroundDecorImage : UIImage {
        return UIImage(named: "DarkButterfly")!
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
    
    // Menu bar color
    var menuBackgroundColor : UIColor {
        return UIColor.black
    }
    
    // Title text color
    var titleTextColor : UIColor {
        return UIColor.white
    }

    // Standard text color
    var standardTextColor : UIColor {
        return UIColor.white
    }

    // Card title color
    var cardTitleColor : UIColor {
        return UIColor(red: 235 / 255.0, green: 235 / 255.0, blue: 235 / 255.0, alpha: 1)
    }

    // Card desc color
    var cardDescColor : UIColor {
        return UIColor(red: 159 / 255.0, green: 159 / 255.0, blue: 159 / 255.0, alpha: 1)
    }
    
    // Description text color
    var descTextColor : UIColor {
        return UIColor(red: 160/255.0, green: 160/255.0, blue: 160/255.0, alpha: 1)
    }

    // Description text font
    var descFont : UIFont {
        return UIFont(name: "AvenirNextCondensed-Regular", size: 15)!
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
        return UIColor(red: 88/255.0, green: 240/255.0, blue: 213/255.0, alpha: 1.0)
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

    // Section view title
    var sectionTitleFont : UIFont {
        return UIFont(name: "HelveticaNeue-CondensedBold", size: 14)!
    }
    
    // Thumbnail font
    var thumbnailFont : UIFont {
        return UIFont(name: "AvenirNextCondensed-Medium", size: 14)!
    }

    // Menu item normal text color
    var menuItemNormalColor : UIColor {
        return UIColor(red: 157 / 255.0, green: 157 / 255.0, blue: 157 / 255.0, alpha: 1.0)
    }

    // Menu item highlighted text color
    var menuItemHighlightedColor : UIColor {
        return UIColor.white
    }

    // Menu title font
    var menuTitleFont : UIFont {
        return UIFont(name: "HelveticaNeue-CondensedBold", size: 14)!
    }
    
    // Menu title color
    var menuTitleColor : UIColor {
        return UIColor.white
    }
    
    // Menu item font
    var menuItemFont : UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: 17)!
    }

    var mainMenuFont : UIFont {
        return UIFont(name: "HelveticaNeue", size: 17)!
    }

    var mainMenuNormalColor : UIColor {
        return UIColor.white
    }

    var mainMenuHighlightColor : UIColor {
        return UIColor(red: 58 / 255.0, green: 139 / 255.0, blue: 235 / 255.0, alpha: 1)
    }

    var separatorColor : UIColor {
        return UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 0.5)
    }

    init(themeType : AppThemeType) {
        self.themeType = themeType
    }
}
