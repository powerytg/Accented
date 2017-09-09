//
//  MainMenuSectionBase.swift
//  Accented
//
//  Created by Tiangong You on 9/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class MainMenuSectionBase: SectionViewBase {
    weak var drawer : UIViewController?
    
    init(drawer : UIViewController) {
        self.drawer = drawer
        super.init(ModelBase())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
