//
//  InlineLoadingView.swift
//  Accented
//
//  Created by You, Tiangong on 5/4/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class InlineLoadingView: UIView {

    var loadingIndicator = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    convenience init() {
        self.init(frame : CGRectZero)
    }

    private func initialize() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.text = "Loading next page..."
        self.addSubview(loadingIndicator)
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: loadingIndicator, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: loadingIndicator, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0))
        NSLayoutConstraint.activateConstraints(constraints)
    }
}
