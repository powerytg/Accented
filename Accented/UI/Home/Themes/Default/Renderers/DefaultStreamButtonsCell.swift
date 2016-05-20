//
//  StreamButtonsCell.swift
//  Accented
//
//  Created by Tiangong You on 5/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DefaultStreamButtonsCell: UICollectionViewCell {

    @IBOutlet weak var streamLabel: UILabel!
    @IBOutlet weak var displayStyleButton: DefaultThemeSelectorButton!
    
    var stream : StreamModel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        streamLabel.textColor = ThemeManager.sharedInstance.currentTheme.titleTextColor
        if let streamModel = stream {
            streamLabel.text = TextUtils.streamDisplayName(streamModel.streamType)
        }
    }
    
    @IBAction func displayButtonDidTap(sender: AnyObject) {
        if ThemeManager.sharedInstance.currentTheme.themeType == .Light {
            ThemeManager.sharedInstance.currentTheme = DarkTheme()
        } else {
            ThemeManager.sharedInstance.currentTheme = LightTheme()
        }
    }
}
