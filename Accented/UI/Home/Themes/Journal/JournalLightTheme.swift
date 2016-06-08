//
//  JournalLightTheme.swift
//  Accented
//
//  Created by You, Tiangong on 5/31/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class JournalLightTheme: JournalDarkTheme {

    override var displayLabel : String {
        return "dream"
    }
    
    override var displayThumbnail : UIImage! {
        return UIImage(named: "JournalLightThemeThumbnail")
    }

    override var streamBackgroundColor: UIColor {
        return UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1.0)
    }

    override var backgroundBlurEffect : UIBlurEffect {
        return UIBlurEffect(style: .ExtraLight)
    }

    override var backgroundLogoImage : UIImage! {
        return UIImage(named: "LightJournalBackgroundLogo")
    }
    
    override var titleHeaderImage : UIImage! {
        return UIImage(named: "LightJournalTitleLogo")
    }

    override var streamBackdropColor : UIColor {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
    }

    override var bubbleDecorImage : UIImage! {
        return UIImage(named: "LightJournalBubble")
    }

    override var titleTextColor: UIColor {
        return UIColor(red: 50 / 255.0, green: 50 / 255.0, blue: 50 / 255.0, alpha: 1)
    }
    
    override var standardTextColor: UIColor {
        return UIColor(red: 101 / 255.0, green: 101 / 255.0, blue: 101 / 255.0, alpha: 1.0)
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

}
