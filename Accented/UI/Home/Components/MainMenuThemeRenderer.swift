//
//  MainMenuThemeRenderer.swift
//  Accented
//
//  Created by Tiangong You on 8/27/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class MainMenuThemeRenderer: UIView {
    private let padding : CGFloat = 12
    private var imageView = UIImageView()
    private var titleLabel = UILabel()

    var theme : AppTheme
    
    init(_ theme : AppTheme) {
        self.theme = theme
        super.init(frame: CGRect.zero)
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = theme.displayThumbnail
        
        titleLabel.font = UIFont(name: "AvenirNext-DemiBoldItalic", size: 17)!
        titleLabel.textColor = UIColor.white
        titleLabel.text = theme.displayLabel
        titleLabel.sizeToFit()
        
        layer.shadowOffset = CGSize(width: 0, height: 1);
        layer.shadowRadius = 3;
        layer.borderColor = UIColor(red: 30 / 255.0, green: 128 / 255.0, blue: 243 / 255.0, alpha: 1.0).cgColor

        if theme == ThemeManager.sharedInstance.currentTheme {
            applySelectedState()
        } else {
            applyUnselectedState()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = self.bounds
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath

        var f = titleLabel.frame
        f.origin.x = padding
        f.origin.y = bounds.height - f.size.height - padding
        titleLabel.frame = f
    }
    
    private func applyUnselectedState() {
        layer.masksToBounds = false;
        layer.shadowOpacity = 0.9;
        layer.cornerRadius = 0;
        layer.borderWidth = 0;
    }
    
    private func applySelectedState() {
        layer.masksToBounds = true;
        layer.cornerRadius = 4;
        layer.borderWidth = 4;
        layer.shadowOpacity = 0;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.applySelectedState()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            if self.theme == ThemeManager.sharedInstance.currentTheme {
                self.applySelectedState()
            }else {
                self.applyUnselectedState()
            }
        }
    }
}
