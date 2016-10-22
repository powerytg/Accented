//
//  ReplyModel.swift
//  Accented
//
//  Created by You, Tiangong on 8/19/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReplyModel: CommentModel {
    var parentId : String!
    
    override init(json:JSON) {
        super.init(json : json)
        parentId = String(json["parent_id"].int!)
    }

}
