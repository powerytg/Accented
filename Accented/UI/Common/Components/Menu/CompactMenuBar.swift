//
//  CompactMenuBar.swift
//  Accented
//
//  A minimized menu bar view
//  Tapping on the view will present the full menu sheet
//
//  Created by You, Tiangong on 8/24/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class CompactMenuBar: UIView {
    // Default menu bar height
    static let defaultHeight : CGFloat = 25
    
    var menuItems = [MenuItem]()
    
    init(_ menuItems : [MenuItem]) {
        self.menuItems = menuItems
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnMenuBar(_:)))
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapOnMenuBar(_ tap : UITapGestureRecognizer) {
        // Show the full menu sheet
        let menuSheet = MenuViewController(menuItems)
        menuSheet.show()
    }
}
