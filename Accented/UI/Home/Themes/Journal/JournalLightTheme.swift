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

}
