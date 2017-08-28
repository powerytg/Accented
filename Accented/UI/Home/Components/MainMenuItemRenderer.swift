//
//  MainMenuItemRenderer.swift
//  Accented
//
//  Created by Tiangong You on 8/27/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class MainMenuItemRenderer: UIView {

    private let imageSize : CGFloat = 28
    private let paddingRight : CGFloat = 10
    private let paddingLeft : CGFloat = 50
    
    private var menuItem : MenuItem
    private var titleLabel = UILabel(frame : CGRect.zero)
    private var imageView = UIImageView()
    
    init(_ menuItem : MenuItem) {
        self.menuItem = menuItem
        super.init(frame: CGRect.zero)
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .right
        titleLabel.lineBreakMode = .byTruncatingMiddle
        titleLabel.textColor = ThemeManager.sharedInstance.currentTheme.menuItemNormalColor
        titleLabel.font = ThemeManager.sharedInstance.currentTheme.mainMenuFont
        titleLabel.text = menuItem.text
        titleLabel.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = bounds.width
        let h = bounds.height
        
        if menuItem is MenuSeparator {
            imageView.isHidden = true
            titleLabel.isHidden = true
        } else if menuItem.image != nil {
            titleLabel.isHidden = true
            
            imageView.image = menuItem.image
            var f = imageView.frame
            f.size.width = imageSize
            f.size.height = imageSize
            f.origin.x = w - paddingRight - f.size.width
            f.origin.y = h / 2 - f.height / 2
            imageView.frame = f
        } else {
            titleLabel.text = menuItem.text
            var f = titleLabel.frame
            f.size.width = w - paddingLeft - paddingRight
            f.origin.x = paddingLeft
            f.origin.y = h / 2 - f.height / 2
            titleLabel.frame = f
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if menuItem is MenuSeparator || menuItem.image != nil {
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.textColor = ThemeManager.sharedInstance.currentTheme.menuItemHighlightedColor
            self.backgroundColor = UIColor.black
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if menuItem is MenuSeparator || menuItem.image != nil {
            return
        }

        UIView.animate(withDuration: 0.2) {
            self.titleLabel.textColor = ThemeManager.sharedInstance.currentTheme.menuItemNormalColor
            self.backgroundColor = UIColor.clear
        }
    }
}
