//
//  DarkTheme.swift
//  Accented
//
//  Created by You, Tiangong on 5/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DarkTheme: AppTheme {

    // Display label
    override var displayLabel : String {
        return "deep (default)"
    }
    
    init() {
        super.init(themeType: .dark)
    }

}
