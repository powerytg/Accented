//
//  DetailMetadataSectionView.swift
//  Accented
//
//  Info section in the detail page, showing photo scores and shooting conditions
//
//  Created by Tiangong You on 8/7/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailMetadataSectionView: DetailSectionViewBase {

    private let rendererHeight : CGFloat = 26
    private var infoEntries = [(String, String)]()
    private var renderers = [UserInfoEntryView]()
    
    private var exifLabel = UILabel()
    
    override func initialize() {
        super.initialize()
        buildInfoEntries()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var nextY : CGFloat = 0
        for renderer in renderers {
            var f = renderer.frame
            f.origin.x = contentLeftPadding
            f.origin.y = nextY
            f.size.width = width
            f.size.height = rendererHeight
            renderer.frame = f
            
            nextY += f.size.height
        }
    }
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        if infoEntries.count > 0 {
            return rendererHeight * CGFloat(infoEntries.count)
        } else {
            return 0
        }
    }
    
    // MARK: - Private
    
    private func buildInfoEntries() {
        infoEntries.removeAll()
        if let rating = photo.rating {
            if rating != 0 {
                infoEntries.append(("RATING", "\(rating)"))
            }
        }
        
        if let views = photo.viewCount {
            if views != 0 {
                infoEntries.append(("VIEWS", "\(views)"))
            }
        }

        if let likes = photo.voteCount {
            if likes != 0 {
                infoEntries.append(("LIKES", "\(likes)"))
            }
        }

        if let camera = photo.camera {
            if camera.lengthOfBytes(using: .utf8) != 0 {
                infoEntries.append(("CAMERA", camera.uppercased()))
            }
        }
        
        if let lens = photo.lens {
            if lens.lengthOfBytes(using: .utf8) != 0 {
                infoEntries.append(("LENS", lens.uppercased()))
            }
        }

        if let aperture = photo.aperture {
            if aperture.lengthOfBytes(using: .utf8) != 0 {
                infoEntries.append(("APERTURE", displayApertureString(aperture).uppercased()))
            }
        }

        // Create renderers
        for entry in infoEntries {
            let renderer = UserInfoEntryView(entry)
            renderers.append(renderer)
            contentView.addSubview(renderer)
        }
    }
    
    private func displayApertureString(_ aperture : String) -> String {
        if aperture.hasPrefix("f") {
            return aperture
        } else {
            return "f/\(aperture)"
        }
    }
    
    override func entranceAnimationWillBegin() {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 0, y: 30)
    }
    
    override func performEntranceAnimation() {
        UIView .addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1, animations: { [weak self] in
            self?.alpha = 1
            self?.transform = CGAffineTransform.identity
        })
    }
}
