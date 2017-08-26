//
//  MenuImageItemRenderer.swift
//  Accented
//
//  Created by You, Tiangong on 8/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class MenuImageItemRenderer: UIView {

    private let paddingLeft : CGFloat = 10
    private let paddingBottom : CGFloat = 10
    private var titleLabel : UILabel!
    private var imageView : UIImageView?
    
    var selected = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    var menuItem : MenuItem
    
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
        
        if let image = menuItem.image {
            imageView = UIImageView(image: image)
            imageView!.contentMode = .scaleAspectFill
            addSubview(imageView!)
        }
        
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var f = titleLabel.frame
        f.origin.x = paddingLeft
        f.origin.y = bounds.height / 2 - f.size.height - paddingBottom
        f.size.width = bounds.width - paddingLeft
        titleLabel.frame = f
        
        if let imageView = imageView {
            imageView.frame = bounds
        }
        
        if selected {
            layer.shadowOffset = CGSize(width: 0, height: 1);
            layer.shadowRadius = 3
            layer.borderColor = UIColor(red: 30 / 255.0, green: 128 / 255.0, blue: 243 / 255.0, alpha: 1.0).cgColor
            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        } else {
            layer.shadowOffset = CGSize(width: 0, height: 0);
            layer.shadowRadius = 0
            layer.shadowPath = nil
        }
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
