//
//  ThemeManager.swift
//  Accented
//
//  Created by You, Tiangong on 5/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class ThemeManager: NSObject {
    
    private let lightTheme = LightTheme()
    private let darkTheme = DarkTheme()
    
    // Current theme, default to dark theme
    private var theme : AppTheme;
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
    private override init() {
        theme = darkTheme
        themes = [darkTheme, lightTheme]
        super.init()
    }

}
