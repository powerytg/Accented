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
    
    var stream : StreamModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let streamModel = self.stream {
            streamTitleView.text = TextUtils.streamCondensedDisplayName(streamModel.streamType).uppercaseString
        }
    }
    
}
