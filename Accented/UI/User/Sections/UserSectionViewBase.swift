//
//  UserSectionViewBase.swift
//  Accented
//
//  Base class of the sections in the about card in the user profile page
//
//  Created by Tiangong You on 5/29/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserSectionViewBase: SectionViewBase {
    
    // User model
    var user : UserModel {
        return model as! UserModel
    }
}
