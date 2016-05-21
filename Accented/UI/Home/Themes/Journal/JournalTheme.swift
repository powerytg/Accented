//
//  JournalTheme.swift
//  Accented
//
//  Created by Tiangong You on 5/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class JournalTheme: AppTheme {
    
    var backgroundLogoImage : UIImage! {
        return UIImage(named: "JournalBackgroundLogo")
    }
    
    var separatorColor : UIColor {
        return UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 0.5)
    }
    
    override var backgroundViewClass: ThemeableBackgroundView.Type {
        return JournalBackgroundView.self
    }
}
