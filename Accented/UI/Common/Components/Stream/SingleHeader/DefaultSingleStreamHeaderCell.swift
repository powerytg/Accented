//
//  DefaultSingleStreamHeaderCell.swift
//  Accented
//
//  Created by You, Tiangong on 8/26/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

protocol DefaultSingleStreamHeaderCellDelegate : NSObjectProtocol {
    func orderButtonDidTap()
    func displayStyleButtonDidTap()
}

class DefaultSingleStreamHeaderCell: UICollectionViewCell {

    @IBOutlet weak var orderButton: PushButton!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var displayStyleButton: PushButton!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate : DefaultSingleStreamHeaderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func orderButtonDidTap(_ sender: AnyObject) {
        delegate?.orderButtonDidTap()
    }
    
    @IBAction func displayStyleButtonDidTap(_ sender: AnyObject) {
        delegate?.displayStyleButtonDidTap()
    }
}
