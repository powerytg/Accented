//
//  JournalDarkTheme.swift
//  Accented
//
//  Created by Tiangong You on 5/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class JournalDarkTheme: JournalTheme {
    
    init() {
        super.init(themeType: .JournalDark)
    }
    
    override var displayLabel : String {
        return "enchanted"
    }
    
    override var displayThumbnail : UIImage! {
        return UIImage(named: "JournalDarkThemeThumbnail")
    }

    override var streamBackgroundColor: UIColor {
        return UIColor(red: 28 / 255.0, green: 30 / 255.0, blue: 34 / 255.0, alpha: 1.0)
    }
    
    override var streamViewModelClass: StreamViewModel.Type {
        return JournalViewModel.self
    }
}
