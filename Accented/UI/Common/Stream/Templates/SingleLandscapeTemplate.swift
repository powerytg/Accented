//
//  SingleLandscapeTemplate.swift
//  Accented
//
//  Created by You, Tiangong on 4/29/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class SingleLandscapeTemplate: StreamLayoutTemplateBase {
    private let maxHeight : CGFloat = 400
    
    required init(photoSizes: Array<CGSize>, maxWidth: CGFloat) {
        super.init(photoSizes: photoSizes, maxWidth: maxWidth)
        generateLayoutMetadata()
    }
    
    private func generateLayoutMetadata() {
        // Simply max out the width
        let size = inputSizes[0]
        let aspectRatio = width / size.width
        height = min(maxHeight, size.height * aspectRatio)
        
        frames = [CGRectMake(0, 0, width, height)]
    }
}
