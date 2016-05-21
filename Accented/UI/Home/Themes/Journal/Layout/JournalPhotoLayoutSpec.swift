//
//  JournalPhotoLayoutSpec.swift
//  Accented
//
//  Created by Tiangong You on 5/20/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class JournalPhotoLayoutSpec: NSObject {
    
    // Top padding
    static let topPadding : CGFloat = 6
    
    // Bottom padding
    static let bottomPadding : CGFloat = 20
    
    // Padding between the title and the subtitle
    static let titleVPadding : CGFloat = 5
    
    // Title horizontal padding
    static let titleHPadding : CGFloat = 40
    
    // Subtitle horizontal padding
    static let subtitleHPadding : CGFloat = 60
    
    // Descriptions horizontal padding
    static let descHPadding : CGFloat = 10
    
    // Padding between the photo and the subtitle, as well between the photo and the descriptions
    static let photoVPadding : CGFloat = 14
    
    // Padding between the description and the footer
    static let descVPadding : CGFloat = 15
    
    // Max lines of title
    static let titleLabelLineCount = 2
    
    // Max lines of subtitle(author / date)
    static let subtitleLineCount = 1
    
    // Max lines of descriptions
    static let descLineCount = 10
    
    // Footer decor height
    static let footerHeight : CGFloat = 14
    
    // Max height of photo
    static let maxPhotoHeight : CGFloat = 240
    
    // Title font
    static let titleFont = UIFont(name: "HelveticaNeue-Thin", size: 30)
    
    // Subtitle font
    static let subtitleFont = UIFont(name: "HelveticaNeue-LightItalic", size: 15)
    
    // Desc font
    static let descFont = UIFont(name: "AvenirNextCondensed-Regular", size: 18)
    
}

