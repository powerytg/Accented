//
//  StreamCardLayoutGenerator.swift
//  Accented
//
//  Created by Tiangong You on 5/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamCardLayoutGenerator: StreamTemplateGenerator {
    
    // Max width / height aspect ratio to allow using single line horizontal layout template
    let singleLandscapeAspectRatio : CGFloat = 1.64

    override func generateLayoutMetadata(photos : [PhotoModel]) -> [StreamLayoutTemplate]{
        if photos.count == 0 {
            return []
        }
        
        var templates : [StreamLayoutTemplate] = []
        var nextIndex = 0
        while nextIndex < photos.count {
            let currentPhoto = photos[nextIndex]
            
            // If there are more than three photos, then always use headline layout for the first three photos
            if photos.count >= 3 && nextIndex == 0{
                let photo1 = currentPhoto
                let photo2 = photos[nextIndex + 1]
                let photo3 = photos[nextIndex + 2]
                
                let template = HeadlineTemplate(photoSizes: [photoSize(photo1), photoSize(photo2), photoSize(photo3)], maxWidth: availableWidth)
                templates.append(template)
                nextIndex += 3
                continue
            }
            
            // Last photo always use landscape or portrait layout
            if currentPhoto == photos.first || currentPhoto == photos.last {
                let template = SingleLandscapeTemplate(photoSizes: [photoSize(currentPhoto)], maxWidth: availableWidth)
                templates.append(template)
                nextIndex += 1
                continue
            }
            
            // The 2nd and 3rd photos use side by side layout, unless there are less than photos all together
            // The same rules apply to the last two photos
            if photos.count > 3 {
                if nextIndex == 1 || nextIndex == photos.count - 2 {
                    let photo1 = currentPhoto
                    let photo2 = photos[nextIndex + 1]
                    let template = SideBySideTemplate(photoSizes: [photoSize(photo1), photoSize(photo2)], maxWidth: availableWidth)
                    templates.append(template)
                    nextIndex += 2
                    continue
                }
            }
            
            // If the width / height aspect ratio exceeds a certain threshold, display the image as one single landscape image
            if shouldUseSingleLandscapeLayout(currentPhoto) {
                let template = SingleLandscapeTemplate(photoSizes: [photoSize(currentPhoto)], maxWidth: availableWidth)
                templates.append(template)
                nextIndex += 1
                continue
            }
            
            // Otherwise, check up the following item's aspect ratio and decide where we should use side by side layout
            let followupPhoto = photos[nextIndex + 1]
            if shouldUseSingleLandscapeLayout(followupPhoto) {
                // Since both photos require landscape layout, cancel the decision of using side by side layout
                let template1 = SingleLandscapeTemplate(photoSizes: [photoSize(currentPhoto)], maxWidth: availableWidth)
                let template2 = SingleLandscapeTemplate(photoSizes: [photoSize(followupPhoto)], maxWidth: availableWidth)
                templates.append(template1)
                templates.append(template2)
                nextIndex += 2
                continue
            } else {
                let template = SideBySideTemplate(photoSizes: [photoSize(currentPhoto), photoSize(followupPhoto)], maxWidth: availableWidth)
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
