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
        return UIImage(named: "DarkJournalBackgroundLogo")
    }
    
    var titleHeaderImage : UIImage! {
        return UIImage(named: "DarkJournalTitleLogo")
    }
    
    var separatorColor : UIColor {
        return UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 0.5)
    }

    override var standardTextColor: UIColor {
        return UIColor(red: 147 / 255.0, green: 147 / 255.0, blue: 147 / 255.0, alpha: 1.0)
    }
    
    override var backgroundViewClass: ThemeableBackgroundView.Type {
        return JournalBackgroundView.self
    }

    var streamBackdropColor : UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }

    var bubbleDecorImage : UIImage! {
        return UIImage(named: "DarkJournalBubble")
    }    
}
