//
//  ThemeManager.swift
//  Accented
//
//  Created by You, Tiangong on 5/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class ThemeManager: NSObject {
    
    fileprivate let lightTheme = LightTheme()
    fileprivate let darkTheme = DarkTheme()
    fileprivate let journalLightTheme = JournalLightTheme()
    fileprivate let journalDarkTheme = JournalDarkTheme()
    
    // Current theme, default to dark theme
    fileprivate var theme : AppTheme;
    var currentTheme : AppTheme {
        get {
            return theme
        }
        
        set(value) {
            if theme != value {
                theme = value
                NotificationCenter.default.post(name: ThemeManagerEvents.appThemeDidChange, object: nil)
            }
        }
    }
    
    // Available themes
    let themes : [AppTheme]
    
    // Singleton instance
    static let sharedInstance = ThemeManager()
    fileprivate override init() {
        theme = journalDarkTheme
        themes = [darkTheme, lightTheme, journalDarkTheme, journalLightTheme]
        super.init()
    }

}
