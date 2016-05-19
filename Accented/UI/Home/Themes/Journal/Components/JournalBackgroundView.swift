//
//  JournalBackgroundView.swift
//  Accented
//
//  Created by Tiangong You on 5/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class JournalBackgroundView: UIView {
    
    var imageView = UIImageView()
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(_ coder: NSCoder? = nil) {
        if let coder = coder {
            super.init(coder: coder)!
        }
        else {
            super.init(frame: CGRectZero)
        }
        
        initialize()
    }
    
    private func initialize() -> Void {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if ThemeManager.sharedInstance.currentTheme is JournalTheme {
            let journalStyle = ThemeManager.sharedInstance.currentTheme as! JournalTheme
            imageView.image = journalStyle.backgroundLogoImage
        } else {
            imageView.image = nil;
        }
    }
}
