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
    private let lightCardTheme = LightCardTheme()
    private let darkCardTheme = DarkCardTheme()
    private let themeKey = "theme"
    
    // Current theme, default to dark theme
    private var theme : AppTheme!
    var currentTheme : AppTheme {
        get {
            return theme
        }
        
        set(value) {
            if theme != value {
                theme = value
                NotificationCenter.default.post(name: ThemeManagerEvents.appThemeDidChange, object: nil)
                saveThemeToCache()
            }
        }
    }
    
    // Available themes
    let themes : [AppTheme]
    
    // Singleton instance
    static let sharedInstance = ThemeManager()
    private override init() {
        themes = [darkTheme, lightTheme, darkCardTheme, lightCardTheme]
        super.init()
        loadThemeFromCache()
    }

    private func saveThemeToCache() {
        if let currentThemeIndex = themes.index(of: currentTheme) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(currentThemeIndex, forKey: themeKey)
            userDefaults.synchronize()
        }
    }
    
    private func loadThemeFromCache() {
        let userDefaults = UserDefaults.standard
        let savedThemeIndex = userDefaults.integer(forKey: themeKey)
        
        // If there's no theme stored in cache, 0 will be returned
        theme = themes[savedThemeIndex]
    }
}
