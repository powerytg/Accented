//
//  DetailUserUtils.swift
//  Accented
//
//  Created by Tiangong You on 9/15/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailUserUtils: NSObject {

    static func preferredAvatarUrl(_ user : UserModel) -> URL? {
        if let avatar = user.avatarUrls[.Default] {
            return URL(string: avatar)
        } else if let avatar = user.avatarUrls[.Large] {
            return URL(string: avatar)
        } else if let avatar = user.avatarUrls[.Small] {
            return URL(string: avatar)
        } else if let avatar = user.avatarUrls[.Tiny] {
            return URL(string: avatar)
        } else {
            return nil
        }
    }
}
