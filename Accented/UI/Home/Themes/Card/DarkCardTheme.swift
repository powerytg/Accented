//
//  DarkCardTheme.swift
//  Accented
//
//  Created by Tiangong You on 8/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class DarkCardTheme: DarkTheme {
    override var displayLabel : String {
        return "moon lore"
    }
    
    override var displayThumbnail : UIImage! {
        return UIImage(named: "JournalDarkThemeThumbnail")
    }

    override var streamViewModelClass : StreamViewModel.Type {
        return StreamCardViewModel.self
    }
    
    override var backgroundViewClass : ThemeableBackgroundView.Type {
        return CardBackgroundView.self
    }
}
