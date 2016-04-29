//
//  TemplateGenerator.swift
//  Accented
//
//  Created by You, Tiangong on 4/29/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class TemplateGenerator: NSObject {
    let availableWidth : CGFloat
    
    // Photos to be processed
    var photos : [PhotoModel]?
    
    let singleLandscapeAspectRatio : CGFloat = 1.64
    
    // Generated rects
    var rects : [CGRect] = []
    
    required init(maxWidth : CGFloat) {
        self.availableWidth = maxWidth
        super.init()        
    }
    
    func generateLayoutTemplates() -> [StreamLayoutTemplateBase] {
        if photos == nil || photos?.count == 0 {
            return []
        }
        
        var templates : [StreamLayoutTemplateBase] = []
        var nextIndex = 0
        while nextIndex < photos!.count {
            let nextPhoto = photos![nextIndex]
            
            // Last photo always use landscape or portrait layout
            if nextPhoto == photos!.first || nextPhoto == photos!.last {
                let template = SingleLandscapeTemplate(photoSizes: [photoSize(nextPhoto)], maxWidth: availableWidth)
                templates.append(template)
                nextIndex += 1
                continue
            }
            
            // The 2nd and 3rd photos use side by side layout, unless there are less than photos all together
            // The same rules apply to the last two photos
            if photos!.count > 3 {
                if nextIndex == 1 || nextIndex == photos!.count - 2 {
                    let photo1 = photos![nextIndex]
                    let photo2 = photos![nextIndex + 1]
                    let template = SideBySideTemplate(photoSizes: [photoSize(photo1), photoSize(photo2)], maxWidth: availableWidth)
                    templates.append(template)
                    nextIndex += 2
                    continue
                }
            }

            // If the width / height aspect ratio exceeds a certain threshold, display the image as one single landscape image
            if shouldUseSingleLandscapeLayout(nextPhoto) {
                let template = SingleLandscapeTemplate(photoSizes: [photoSize(nextPhoto)], maxWidth: availableWidth)
                templates.append(template)
                nextIndex += 1
                continue
            }
            
            // Otherwise, check up the following item's aspect ratio and decide where we should use side by side layout
            let followupPhoto = photos![nextIndex + 1]
            if shouldUseSingleLandscapeLayout(followupPhoto) {
                // Since both photos require landscape layout, cancel the decision of using side by side layout
                let template1 = SingleLandscapeTemplate(photoSizes: [photoSize(nextPhoto)], maxWidth: availableWidth)
                let template2 = SingleLandscapeTemplate(photoSizes: [photoSize(followupPhoto)], maxWidth: availableWidth)
                templates += [template1, template2]
                nextIndex += 2
                continue
            } else {
                let template = SideBySideTemplate(photoSizes: [photoSize(nextPhoto), photoSize(followupPhoto)], maxWidth: availableWidth)
                templates.append(template)
                nextIndex += 2
                continue
            }
            
        }
        
        return templates
    }
    
    private func shouldUseSingleLandscapeLayout(photo : PhotoModel) -> Bool {
        let aspectRatio = photo.width / photo.height
        return (aspectRatio >= singleLandscapeAspectRatio)
    }
    
    private func photoSize(photo : PhotoModel) -> CGSize {
        return CGSizeMake(CGFloat(photo.width), CGFloat(photo.height))
    }

}
