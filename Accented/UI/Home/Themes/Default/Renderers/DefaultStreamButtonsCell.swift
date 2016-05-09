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
            streamLabel.text = displayName(streamModel.streamType)
        }
    }
    
    private func displayName(streamType : StreamType) -> String {
        switch streamType {
        case .Popular:
            return "Popular Photos"
        case .Editors:
            return "Editors' Choice"
        case .FreshToday:
            return "Fresh Today"
        case .FreshWeek:
            return "Fresh This Week"
        case .FreshYesterday:
            return "Fresh Yesterday"
        case .HighestRated:
            return "Highest Rated"
        case .Upcoming:
            return "Upcoming Photos"
        case .User:
            return "User Photos"
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
