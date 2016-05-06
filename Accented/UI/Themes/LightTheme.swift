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
        return UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
    }

    init() {
        super.init(themeType: .Light)
    }
    
}
