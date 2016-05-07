//
//  StreamSectionFooterCell.swift
//  Accented
//
//  Created by Tiangong You on 5/2/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamSectionFooterCell: UICollectionViewCell {

    @IBOutlet weak var footerLabel: UILabel!
    
    var photoGroup : [PhotoModel]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Footer label
        if ThemeManager.sharedInstance.currentTheme.themeType == .Light {
            footerLabel.textColor = UIColor(red: 70/255.0, green: 70/255.0, blue: 70/255.0, alpha: 1)
        } else {
            footerLabel.textColor = UIColor(red: 203/255.0, green: 203/255.0, blue: 203/255.0, alpha: 1)
        }
        
        if photoGroup != nil {
            var names = [String]()
            for photo in photoGroup! {
                let trimmedName = photo.firstName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                if trimmedName.characters.count > 0 {
                    names.append(trimmedName.uppercaseString)
                }
            }
            
            var displayText = "BY "
            for (index, name) in names.enumerate() {
                displayText += name
                if index == names.count - 2 {
                    displayText += " AND "
                } else if index < names.count - 2 {
                    displayText += ", "
                }
            }
            
            footerLabel.text = displayText
        }
    }

}
