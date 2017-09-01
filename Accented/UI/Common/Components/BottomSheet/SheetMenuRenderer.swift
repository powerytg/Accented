//
//  SheetMenuRenderer.swift
//  Accented
//
//  Created by Tiangong You on 8/31/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class SheetMenuRenderer: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    private let normalBackgroundColor = UIColor.clear
    private let highlightBackgroundColor = UIColor(red: 27 / 255.0, green: 27 / 255.0, blue: 27 / 255.0, alpha: 1.0)
    private let normalTextColor = UIColor(red: 157 / 255.0, green: 157 / 255.0, blue: 157 / 255.0, alpha: 1.0)
    private let highlightTextColor = UIColor.white
    private let highlightFont = UIFont(name: "HelveticaNeue", size: 17)!
    private let normalFont = UIFont(name: "HelveticaNeue-Light", size: 17)!
    
    var menuItem : MenuItem?
    
    init(menuItem : MenuItem, identifier : String) {
        self.menuItem = menuItem
        super.init(style: .default, reuseIdentifier: identifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            backgroundColor = highlightBackgroundColor
            titleLabel.textColor = highlightTextColor
            titleLabel.font = highlightFont
        } else {
            backgroundColor = normalBackgroundColor
            titleLabel.textColor = normalTextColor
            titleLabel.font = normalFont
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            backgroundColor = highlightBackgroundColor
            titleLabel.textColor = highlightTextColor
        } else {
            backgroundColor = normalBackgroundColor
            titleLabel.textColor = normalTextColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let menuItem = self.menuItem {
            titleLabel.text = menuItem.text
        }
    }
}
