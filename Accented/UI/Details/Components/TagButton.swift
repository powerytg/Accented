//
//  TagButton.swift
//  Accented
//
//  Tag button
//
//  Created by Tiangong You on 6/1/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class TagButton: UIButton {
    private let tagButtonInset = UIEdgeInsetsMake(4, 8, 4, 8)
    private let tagButtonBackground = UIColor(red: 32 / 255.0, green: 32 / 255.0, blue: 32 / 255.0, alpha: 1)
    private let tagButtonActiveBackground = UIColor(red: 128 / 255.0, green: 128 / 255.0, blue: 128 / 255.0, alpha: 0.5)
    private let tagButtonBorderColor = UIColor.black
    private let tagButtonRadius : CGFloat = 4
    private let tagButtonFont = UIFont(name: "AvenirNextCondensed-Medium", size: 15)!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize() {
        titleLabel?.font = tagButtonFont
        setTitleColor(UIColor.white, for: .normal)
        contentEdgeInsets = tagButtonInset
        layer.cornerRadius = tagButtonRadius
        layer.borderWidth = 1.0
        layer.borderColor = tagButtonBorderColor.cgColor
        backgroundColor = tagButtonBackground
    }
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? tagButtonActiveBackground : tagButtonBackground
        }
    }
}
