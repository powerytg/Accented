//
//  UserStreamHeaderCell.swift
//  Accented
//
//  Created by Tiangong You on 8/23/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserStreamHeaderCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    var user : UserModel? {
        didSet {
            if user != nil {
                titleLabel.text = "\(user!.userName.uppercased())'S PUBLIC PHOTOS"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
