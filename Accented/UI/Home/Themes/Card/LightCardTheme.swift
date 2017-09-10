//
//  LightCardTheme.swift
//  Accented
//
//  Created by Tiangong You on 8/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class LightCardTheme: LightTheme {
    override var displayLabel : String {
        return "dream"
    }
    
    override var displayThumbnail : UIImage! {
        return UIImage(named: "JournalLightThemeThumbnail")
    }

    override var streamViewModelClass : StreamViewModel.Type {
        return StreamCardViewModel.self
    }
    
    override var backgroundViewClass : ThemeableBackgroundView.Type {
        return CardBackgroundView.self
    }
}
