//
//  StreamSectionFooterCell.swift
//  Accented
//
//  Created by Tiangong You on 5/2/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DefaultStreamSectionFooterCell: UICollectionViewCell {

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
        footerLabel.textColor = ThemeManager.sharedInstance.currentTheme.footerTextColor
        
        if photoGroup != nil {
            var names = [String]()
            for photo in photoGroup! {
                if photo.user.firstName == nil && photo.user.fullName == nil {
                    continue
                }
                
                let name = (photo.user.firstName == nil) ? photo.user.fullName : photo.user.firstName
                let trimmedName = name!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if trimmedName.characters.count > 0 {
                    names.append(trimmedName.uppercased())
                }
            }
            
            var displayText = "BY "
            for (index, name) in names.enumerated() {
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
