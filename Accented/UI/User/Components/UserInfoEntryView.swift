//
//  UserInfoEntryView.swift
//  Accented
//
//  Simple renderer for key value pair in the user profile about section
//
//  Created by Tiangong You on 5/29/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserInfoEntryView: UIView {

    fileprivate var infoEntry : (String, String)
    fileprivate var nameLabel = UILabel()
    fileprivate var valueLabel = UILabel()
    fileprivate let nameColor = UIColor(red: 202 / 255.0, green: 202 / 255.0, blue: 202 / 255.0, alpha: 1.0)
    fileprivate let valueColor = UIColor(red: 104 / 255.0, green: 104 / 255.0, blue: 104 / 255.0, alpha: 1.0)
    fileprivate let nameFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 15)!
    fileprivate let valueFont = UIFont(name: "AvenirNextCondensed-Regular", size: 15)!
    fileprivate let paddingLeft : CGFloat = 6
    fileprivate let paddingRight : CGFloat = 6
    fileprivate let gap : CGFloat = 8
    
    init(_ entry : (String, String)) {
        self.infoEntry = entry
        super.init(frame: CGRect.zero)
        
        addSubview(nameLabel)
        addSubview(valueLabel)
        
        nameLabel.text = infoEntry.0
        nameLabel.font = nameFont
        nameLabel.textColor = nameColor
        nameLabel.sizeToFit()
        
        valueLabel.text = infoEntry.1
        valueLabel.font = valueFont
        valueLabel.textColor = valueColor
        valueLabel.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var nextX : CGFloat = paddingLeft
        var f = nameLabel.frame
        f.origin.x = nextX
        f.origin.y = bounds.size.height / 2 - f.size.height / 2
        nameLabel.frame = f
        nextX += f.size.width + gap

        f = valueLabel.frame
        f.origin.x = nextX
        f.origin.y = bounds.size.height / 2 - f.size.height / 2
        valueLabel.frame = f
    }
    
    func adjustTextClarity() {
        nameLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        nameLabel.layer.shadowOpacity = 1
        nameLabel.layer.shadowRadius = 1
        nameLabel.layer.shadowOpacity = 0.6
        
        valueLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        valueLabel.layer.shadowOpacity = 1
        valueLabel.layer.shadowRadius = 1
        valueLabel.layer.shadowOpacity = 0.6
        valueLabel.textColor = UIColor(red: 180 / 255.0, green: 180 / 255.0, blue: 180 / 255.0, alpha: 1.0)
    }
}
