//
//  SearchResultSortingOptionRenderer.swift
//  Accented
//
//  Created by Tiangong You on 5/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class SearchResultSortingOptionRenderer: UITableViewCell {
    
    @IBOutlet weak var optionLabel: UILabel!
    
    fileprivate let normalBackgroundColor = UIColor.clear
    fileprivate let highlightBackgroundColor = UIColor(red: 27 / 255.0, green: 27 / 255.0, blue: 27 / 255.0, alpha: 1.0)
    fileprivate let normalTextColor = UIColor(red: 157 / 255.0, green: 157 / 255.0, blue: 157 / 255.0, alpha: 1.0)
    fileprivate let highlightTextColor = UIColor.white
    fileprivate let highlightFont = UIFont(name: "HelveticaNeue", size: 17)!
    fileprivate let normalFont = UIFont(name: "HelveticaNeue-Light", size: 17)!
    
    var option : PhotoSearchSortingOptions?
    
    init(option : PhotoSearchSortingOptions, identifier : String) {
        self.option = option
        super.init(style: .default, reuseIdentifier: identifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    fileprivate func initialize() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            backgroundColor = highlightBackgroundColor
            optionLabel.textColor = highlightTextColor
            optionLabel.font = highlightFont
        } else {
            backgroundColor = normalBackgroundColor
            optionLabel.textColor = normalTextColor
            optionLabel.font = normalFont
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        if highlighted {
            backgroundColor = highlightBackgroundColor
            optionLabel.textColor = highlightTextColor
        } else {
            backgroundColor = normalBackgroundColor
            optionLabel.textColor = normalTextColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let option = self.option {
            optionLabel.text = TextUtils.sortOptionDisplayName(option)
        }
    }
}
