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
    @IBOutlet weak var photoCountLabel: UILabel!
    @IBOutlet weak var displayStyleButton: PushButton!
    
    var user : UserModel? {
        didSet {
            if user != nil {
                let userName = TextUtils.preferredAuthorName(user!).uppercased()
                titleLabel.text = "\(userName)'S \nPUBLIC PHOTOS"
                
                if let photoCount = user!.photoCount {
                    if photoCount == 0 {
                        photoCountLabel.text = "NO ITEMS"
                    } else if photoCount == 1 {
                        photoCountLabel.text = "1 ITEM"
                    } else {
                        photoCountLabel.text = "\(photoCount) ITEMS"
                    }
                } else {
                    photoCountLabel.isHidden = true
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func displayStyleButtonDidTap(_ sender: Any) {
        NotificationCenter.default.post(name: StreamEvents.didRequestChangeDisplayStyle, object: nil)
    }
}
