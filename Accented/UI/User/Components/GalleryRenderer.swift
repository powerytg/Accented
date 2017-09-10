//
//  GalleryRenderer.swift
//  Accented
//
//  Created by Tiangong You on 8/23/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import SDWebImage

class GalleryRenderer: UIView {
    
    var gallery : GalleryModel? {
        didSet {
            setNeedsLayout()
        }
    }
    
    var imageView : UIImageView!
    var titleLabel : UILabel!
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)

        imageView = UIImageView(frame: self.bounds)
        addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        titleLabel = UILabel(frame: self.bounds)
        addSubview(titleLabel)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingMiddle
        titleLabel.textColor = UIColor.white
        titleLabel.font = ThemeManager.sharedInstance.currentTheme.thumbnailFont
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowRadius = 1
        titleLabel.layer.shadowOpacity = 0.6
        
        // Apply drop shadow
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        // Events
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnRenderer(_:)))
        addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let gallery = self.gallery else { return }
        
        // Set title
        titleLabel.text = gallery.name
        let maxTitleSize = CGSize(width: bounds.size.width / 2, height: bounds.size.height / 2)
        let measuredTitleSize = titleLabel.sizeThatFits(maxTitleSize)
        var f = titleLabel.frame
        f.origin.x = 8
        f.origin.y = bounds.size.height - measuredTitleSize.height - 8
        f.size.width = measuredTitleSize.width
        f.size.height = measuredTitleSize.height
        titleLabel.frame = f
        
        guard let coverUrlString = gallery.coverPhotoUrl else {
            imageView.image = nil
            return
        }
        
        guard let coverUrl = URL(string: coverUrlString) else {
            imageView.image = nil
            return
        }
        
        // Set thumbnail image
        imageView.frame = self.bounds
        imageView.sd_setImage(with: coverUrl)
    }
    
    // MARK: - Events
    @objc private func didTapOnRenderer(_ sender : UITapGestureRecognizer) {
        if let gallery = self.gallery {
            NavigationService.sharedInstance.navigateToGalleryPage(gallery: gallery)
        }
    }
}
