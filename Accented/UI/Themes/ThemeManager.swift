//
//  ThemeManager.swift
//  Accented
//
//  Created by You, Tiangong on 5/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class ThemeManager: NSObject {
    
    // Current theme, default to dark theme
    var currentTheme : AppTheme
    
    // Singleton instance
    static let sharedInstance = ThemeManager()
    private override init() {
        currentTheme = DarkTheme()
    }

}
