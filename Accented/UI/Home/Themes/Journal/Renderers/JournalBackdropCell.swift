//
//  JournalBackdropCell.swift
//  Accented
//
//  Created by Tiangong You on 5/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class JournalBackdropCell: UICollectionReusableView {
    
    var journalTheme : JournalTheme {
        return ThemeManager.sharedInstance.currentTheme as! JournalTheme
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyTheme()
    }
    
    private func applyTheme() {
        if ThemeManager.sharedInstance.currentTheme is JournalTheme {
            self.backgroundColor = journalTheme.streamBackdropColor
        } else {
            self.backgroundColor = nil
        }
    }
}
