//
//  LightTheme.swift
//  Accented
//
//  Created by You, Tiangong on 5/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class LightTheme: AppTheme {

    override var displayLabel : String {
        return "arc"
    }
    
    override var displayThumbnail : UIImage! {
        return UIImage(named: "LightThemeThumbnail")
    }

    override var rootViewBackgroundColor: UIColor {
        return UIColor.white
    }
    
    override var backgroundDecorImage: UIImage {
        return UIImage(named: "LightButterfly")!
    }
    
    override var streamBackgroundColor : UIColor {
        return UIColor.white
    }

    override var backgroundBlurEffect : UIBlurEffect {
        return UIBlurEffect(style: .extraLight)
    }
    
    override var shouldUseDesaturatedBackground : Bool {
        return false
    }

    override var menuBarBackgroundColor : UIColor {
        return UIColor.white
    }

    override var menuSheetBackgroundColor : UIColor {
        return UIColor.white
    }

    override var titleTextColor : UIColor {
        return UIColor(red: 80 / 255.0, green: 80 / 255.0, blue: 80 / 255.0, alpha: 1.0)
    }
    
    override var subtitleTextColor: UIColor {
        return UIColor(red: 100 / 255.0, green: 100 / 255.0, blue: 100 / 255.0, alpha: 1.0)
    }

    override var standardTextColor : UIColor {
        return UIColor(red: 60 / 255.0, green: 60 / 255.0, blue: 60 / 255.0, alpha: 1.0)
    }
    
    // Card title color
    override var cardTitleColor : UIColor {
        return UIColor(red: 114 / 255.0, green: 114 / 255.0, blue: 114 / 255.0, alpha: 1)
    }
    
    // Card desc color
    override var cardDescColor : UIColor {
        return UIColor(red: 100 / 255.0, green: 100 / 255.0, blue: 100 / 255.0, alpha: 1)
    }

    override var statusBarStyle : UIStatusBarStyle {
        return .default
    }

    override var footerTextColor : UIColor {
        return UIColor(red: 70/255.0, green: 70/255.0, blue: 70/255.0, alpha: 1)
    }

    override var navButtonNormalColor : UIColor {
        return UIColor(red: 60/255.0, green: 60/255.0, blue: 60/255.0, alpha: 1.0)
    }

    override var navBarBorderColor : UIColor {
        return UIColor(red: 72/255.0, green: 72/255.0, blue: 72/255.0, alpha: 1.0)
    }

    override var pushButtonBorderColor : UIColor {
        return UIColor(red: 100 / 255.0, green: 100 / 255.0, blue: 100 / 255.0, alpha: 1)
    }
    
    override var pushButtonBackgroundColor : UIColor {
        return UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 0.9)
    }
    
    override var pushButtonTextColor : UIColor {
        return UIColor(red: 76 / 255.0, green: 76 / 255.0, blue: 76 / 255.0, alpha: 1)
    }

    override var navButtonSelectedColor : UIColor {
        return UIColor(red: 143/255.0, green: 167/255.0, blue: 183/255.0, alpha: 1.0)
    }

    override var mainMenuNormalColor : UIColor {
        return UIColor(red: 66/255.0, green: 66/255.0, blue: 66/255.0, alpha: 1)
    }

    override var mainMenuHighlightColor: UIColor {
        return UIColor(red: 143/255.0, green: 167/255.0, blue: 183/255.0, alpha: 1.0)
    }
    
    override var menuTitleColor: UIColor {
        return UIColor(red: 66/255.0, green: 66/255.0, blue: 66/255.0, alpha: 1)
    }
    
    override var menuItemNormalColor : UIColor {
        return UIColor(red: 66 / 255.0, green: 66 / 255.0, blue: 66 / 255.0, alpha: 1.0)
    }

    override var drawerUseBlurBackground : Bool {
        return true
    }

    override var commentBubbleTextColor : UIColor {
        return UIColor(red: 100 / 255.0, green: 103 / 255.0, blue: 113 / 255.0, alpha: 1)
    }

    override var loadingSpinnerStyle : UIActivityIndicatorViewStyle {
        return .gray
    }

    override var deckNavUnselectedTextColor : UIColor {
        return UIColor(red: 81 / 255.0, green: 81 / 255.0, blue: 81 / 255.0, alpha: 1)
    }
    
    override var deckNavSelectedTextColor : UIColor {
        return UIColor(red: 143/255.0, green: 167/255.0, blue: 183/255.0, alpha: 1.0)
    }

    override var detailEntryViewNameTextColor : UIColor {
        return UIColor(red: 143/255.0, green: 167/255.0, blue: 183/255.0, alpha: 1.0)
    }

    override var detailEntryValueTextColor: UIColor {
        return UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
    }
    
    override var composerBackground : UIColor {
        return UIColor.white
    }

    override var composerTextColor : UIColor {
        return UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
    }
    
    override var composerPlaceholderTextColor : UIColor {
        return UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1)
    }

    override var userProfileDescTextColor: UIColor {
        return UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
    }

    override var descTextColorHex : String {
        return "#767676"
    }

    override var aboutTextColor: UIColor {
        return UIColor(red: 66/255.0, green: 66/255.0, blue: 66/255.0, alpha: 1)
    }
    
    init() {
        super.init(themeType: .light)
    }
    
}
