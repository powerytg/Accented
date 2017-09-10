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

    override var titleTextColor : UIColor {
        return UIColor(red: 80 / 255.0, green: 80 / 255.0, blue: 80 / 255.0, alpha: 1.0)
    }

    override var standardTextColor : UIColor {
        return UIColor(red: 60 / 255.0, green: 60 / 255.0, blue: 60 / 255.0, alpha: 1.0)
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

    init() {
        super.init(themeType: .light)
    }
    
}
