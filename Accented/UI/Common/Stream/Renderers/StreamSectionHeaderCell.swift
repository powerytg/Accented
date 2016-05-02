//
//  StreamSectionHeaderCell.swift
//  Accented
//
//  Created by Tiangong You on 5/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamSectionHeaderCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    var photoGroup : [PhotoModel]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if photoGroup != nil {
            var names = [String]()
            for photo in photoGroup! {
                names.append(photo.firstName)
            }
            
            let nameString = names.joinWithSeparator(", ").uppercaseString
            let displayText = "BY \(nameString)"
            titleLabel.text = displayText
        }
    }
    
}
