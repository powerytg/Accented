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
    private var theme : AppTheme = JournalLightTheme()
    var currentTheme : AppTheme {
        get {
            return theme
        }
        
        set(value) {
            if theme != value {
                theme = value
                NSNotificationCenter.defaultCenter().postNotificationName(ThemeManagerEvents.appThemeDidChange, object: nil)
            }
        }
    }
    
    // Singleton instance
    static let sharedInstance = ThemeManager()
    private override init() {
        
    }

}
