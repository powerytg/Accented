//
//  FatalErrorView.swift
//  Accented
//
//  Error handling view for fatal errors
//  List of fatal errors may include:
//  
//  * No camera
//  * No camera permission
//  * Parental control
//  * Camera failed to initialize for some reasons
//
//  Created by Tiangong You on 6/3/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class FatalErrorView: UIView {

    let padding : CGFloat = 30
    let gap : CGFloat = 25
    let label = UILabel()
    let button = PushButton()
    var action : (() -> Void)
    
    init(frame: CGRect, title : String, buttonTitle : String, action : @escaping (() -> Void)) {
        self.action = action
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black
        
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.text = title
        label.numberOfLines = 0
        label.textAlignment = .center
        label.frame.size.width = frame.width - padding * 2
        label.sizeToFit()
        addSubview(label)
        
        button.setTitle(buttonTitle, for: .normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8)
        button.sizeToFit()
        addSubview(button)
        
        // Events
        button.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let totalHeight = label.frame.height + button.frame.height + gap
        
        var f = label.frame
        f.origin.x = bounds.width / 2 - f.width / 2
        f.origin.y = bounds.height / 2 - totalHeight / 2
        label.frame = f
        
        f = button.frame
        f.origin.x = bounds.width / 2 - f.width / 2
        f.origin.y = label.frame.maxY + 25
        button.frame = f
    }
    
    @objc private func buttonDidTap(_ sender : PushButton) {
        action()
    }

}
