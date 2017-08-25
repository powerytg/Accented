//
//  MenuItemRenderer.swift
//  Accented
//
//  Bottom sheet menu item renderer
//
//  Created by You, Tiangong on 8/24/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class MenuItemRenderer: UIView {

    private let paddingLeft : CGFloat = 34
    private let paddingRight : CGFloat = 25
    var menuItem : MenuItem
    private var titleLabel : UILabel!
    
    init(_ menuItem : MenuItem) {
        self.menuItem = menuItem
        super.init(frame: CGRect.zero)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingMiddle
        titleLabel.textColor = ThemeManager.sharedInstance.currentTheme.menuItemNormalColor
        titleLabel.font = ThemeManager.sharedInstance.currentTheme.menuItemFont
        titleLabel.text = menuItem.text
        titleLabel.sizeToFit()
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        var f = titleLabel.frame
        f.origin.x = paddingLeft
        f.origin.y = bounds.height / 2 - f.height / 2
        f.size.width = bounds.width - paddingLeft - paddingRight
        titleLabel.frame = f
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) { 
            self.titleLabel.textColor = ThemeManager.sharedInstance.currentTheme.menuItemHighlightedColor
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.textColor = ThemeManager.sharedInstance.currentTheme.menuItemNormalColor
        }
    }
}
