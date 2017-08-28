//
//  MainMenuThemeSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/27/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class MainMenuThemeSectionView: SectionViewBase {
    private let paddingTop : CGFloat = 15
    private let paddingLeft : CGFloat = 20
    private let paddingRight : CGFloat = 20
    private let rowHeight : CGFloat = 150
    private let gap : CGFloat = 14
    
    var renderers = [MainMenuThemeRenderer]()
    
    override func initialize() {
        super.initialize()

        for theme in ThemeManager.sharedInstance.themes {
            let renderer = MainMenuThemeRenderer(theme)
            contentView.addSubview(renderer)
            renderers.append(renderer)
        }
    }
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        return (rowHeight + gap) * CGFloat(ThemeManager.sharedInstance.themes.count) + paddingTop
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var nextY : CGFloat = paddingTop
        for renderer in renderers {
            var f = renderer.frame
            f.size.width = contentView.bounds.size.width - paddingLeft - paddingRight
            f.size.height = rowHeight
            f.origin.x = paddingLeft
            f.origin.y = nextY
            renderer.frame = f
            
            nextY += rowHeight + gap
        }
    }
}
