//
//  StreamHeaderCell.swift
//  Accented
//
//  Created by Tiangong You on 5/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamHeaderCell: UICollectionViewCell {

    @IBOutlet weak var titleView: UIImageView!
    @IBOutlet weak var streamSelectorView: StreamSelectorView!
    @IBOutlet weak var streamLabel: UILabel!
    
    var stream : StreamModel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        streamSelectorView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let streamModel = stream {
            streamLabel.text = displayName(streamModel.streamType)
        }
    }
    
    private func displayName(streamType : StreamType) -> String {
        switch streamType {
        case .Popular:
            return "Popular Photos"
        case .Editors:
            return "Editors' Choice"
        case .FreshToday:
            return "Fresh Today"
        case .FreshWeek:
            return "Fresh This Week"
        case .FreshYesterday:
            return "Fresh Yesterday"
        case .HighestRated:
            return "Highest Rated"
        case .Upcoming:
            return "Upcoming Photos"
        case .User:
            return "User Photos"
        default:
            return "Photo Stream"
        }
    }
    
}
