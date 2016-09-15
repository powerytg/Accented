//
//  JournalHeaderTitleCell.swift
//  Accented
//
//  Created by You, Tiangong on 5/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import Foundation

class JournalHeaderTitleCell: UICollectionViewCell {

    @IBOutlet weak var themeButton: DefaultThemeSelectorButton!
    @IBOutlet weak var streamTitleView: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    
    var stream : StreamModel?
    
    var journalTheme : JournalTheme {
        return ThemeManager.sharedInstance.currentTheme as! JournalTheme
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let streamModel = self.stream {
            streamTitleView.text = TextUtils.streamCondensedDisplayName(streamModel.streamType).uppercased()
        }
        
        if ThemeManager.sharedInstance.currentTheme is JournalTheme {
            titleImageView.image = journalTheme.titleHeaderImage
        } else {
            titleImageView.image = nil;
        }
    }
    
    @IBAction func themeButtonDidTap(_ sender: AnyObject) {
        NotificationCenter.default.post(name: StreamEvents.didRequestRightDrawer, object: nil)
    }
}
