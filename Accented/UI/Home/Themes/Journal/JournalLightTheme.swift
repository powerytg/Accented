//
//  JournalLightTheme.swift
//  Accented
//
//  Created by You, Tiangong on 5/31/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class JournalLightTheme: JournalDarkTheme {

    override var streamBackgroundColor: UIColor {
        return UIColor.whiteColor()
    }

    override var backgroundBlurEffect : UIBlurEffect {
        return UIBlurEffect(style: .ExtraLight)
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
