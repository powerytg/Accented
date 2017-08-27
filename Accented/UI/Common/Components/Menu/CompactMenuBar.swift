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
    static let defaultHeight : CGFloat = 26
    
    private var title : String?
    private var iconView : UIImageView!
    var menuItems = [MenuItem]()
    
    weak var delegate : MenuDelegate?
    
    init(_ menuItems : [MenuItem], title : String? = nil) {
        self.menuItems = menuItems
        self.title = title
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.black
        
        iconView = UIImageView(image: UIImage(named: "MenuIcon"))
        iconView.sizeToFit()
        addSubview(iconView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnMenuBar(_:)))
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var f = iconView.frame
        f.origin.x = bounds.width - f.width - 12
        f.origin.y = bounds.height - f.height - 8
        iconView.frame = f
    }
    
    @objc private func didTapOnMenuBar(_ tap : UITapGestureRecognizer) {
        // Show the full menu sheet
        let menuSheet = MenuViewController(menuItems)
        menuSheet.title = title
        menuSheet.delegate = delegate
        menuSheet.show()
    }
}
