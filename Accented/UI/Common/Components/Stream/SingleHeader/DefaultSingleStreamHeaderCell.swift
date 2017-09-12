//
//  DefaultSingleStreamHeaderCell.swift
//  Accented
//
//  Created by You, Tiangong on 8/26/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class DefaultSingleStreamHeaderCell: UICollectionViewCell {

    @IBOutlet weak var orderButton: PushButton!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var displayStyleButton: PushButton!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = ThemeManager.sharedInstance.currentTheme.titleTextColor
        subtitleLabel.textColor = ThemeManager.sharedInstance.currentTheme.subtitleTextColor
        orderLabel.textColor = ThemeManager.sharedInstance.currentTheme.subtitleTextColor
    }

    @IBAction func orderButtonDidTap(_ sender: AnyObject) {
        NotificationCenter.default.post(name: StreamEvents.didRequestChangeSortingOptions, object: nil)
    }
    
    @IBAction func displayStyleButtonDidTap(_ sender: AnyObject) {
        NotificationCenter.default.post(name: StreamEvents.didRequestChangeDisplayStyle, object: nil)        
    }
}
