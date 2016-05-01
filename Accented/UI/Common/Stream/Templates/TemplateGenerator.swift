//
//  TemplateGenerator.swift
//  Accented
//
//  Created by You, Tiangong on 4/29/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class TemplateGenerator: NSObject {
    
    private var storedPhotos = [PhotoModel]()
    var photos : [PhotoModel] {
        get {
            return storedPhotos
        }
        
        set(value) {
            let previousCount = storedPhotos.count
            storedPhotos = value
            
            let startIndex = previousCount
            let endIndex = storedPhotos.count - 1
            let photosForProcessing = Array(storedPhotos[startIndex...endIndex])
            generateLayoutTemplates(photosForProcessing)
        }
    }
    
    // Data model represents grouped photos
    typealias PhotoGroup = [PhotoModel]
    
    // Available width
    let availableWidth : CGFloat
    
    // Max width / height aspect ratio to allow using single line horizontal layout template
    let singleLandscapeAspectRatio : CGFloat = 1.64
    
    // Cached photo groups
    var photoGroups = [PhotoGroup]()
    
    // Cached templates
    var templates = [StreamLayoutTemplate]()
    
    required init(maxWidth : CGFloat) {
        self.availableWidth = maxWidth
        super.init()        
    }
    
    private func generateLayoutTemplates(photosForProcessing : [PhotoModel]){
        if photosForProcessing.count == 0 {
            return
        }
        
        var nextIndex = 0
        while nextIndex < photosForProcessing.count {
            let currentPhoto = photosForProcessing[nextIndex]
            
            // If there are more than three photos, then always use headline layout for the first three photos
            if photosForProcessing.count >= 3 && nextIndex == 0{
                let photo1 = currentPhoto
                let photo2 = photosForProcessing[nextIndex + 1]
                let photo3 = photosForProcessing[nextIndex + 2]

                let template = HeadlineTemplate(photoSizes: [photoSize(photo1), photoSize(photo2), photoSize(photo3)], maxWidth: availableWidth)
                templates.append(template)
                photoGroups.append([photo1, photo2, photo3])
                nextIndex += 3
                continue
            }
            
            // Last photo always use landscape or portrait layout
            if currentPhoto == photosForProcessing.first || currentPhoto == photosForProcessing.last {
                let template = SingleLandscapeTemplate(photoSizes: [photoSize(currentPhoto)], maxWidth: availableWidth)
                templates.append(template)
                photoGroups.append([currentPhoto])
                nextIndex += 1
                continue
            }
            
            // The 2nd and 3rd photos use side by side layout, unless there are less than photos all together
            // The same rules apply to the last two photos
            if photosForProcessing.count > 3 {
                if nextIndex == 1 || nextIndex == photosForProcessing.count - 2 {
                    let photo1 = currentPhoto
                    let photo2 = photosForProcessing[nextIndex + 1]
                    let template = SideBySideTemplate(photoSizes: [photoSize(photo1), photoSize(photo2)], maxWidth: availableWidth)
                    templates.append(template)
                    photoGroups.append([photo1, photo2])
                    nextIndex += 2
                    continue
                }
            }

            // If the width / height aspect ratio exceeds a certain threshold, display the image as one single landscape image
            if shouldUseSingleLandscapeLayout(currentPhoto) {
                let template = SingleLandscapeTemplate(photoSizes: [photoSize(currentPhoto)], maxWidth: availableWidth)
                templates.append(template)
                photoGroups.append([currentPhoto])
                nextIndex += 1
                continue
            }
            
            // Otherwise, check up the following item's aspect ratio and decide where we should use side by side layout
            let followupPhoto = photosForProcessing[nextIndex + 1]
            if shouldUseSingleLandscapeLayout(followupPhoto) {
                // Since both photos require landscape layout, cancel the decision of using side by side layout
                let template1 = SingleLandscapeTemplate(photoSizes: [photoSize(currentPhoto)], maxWidth: availableWidth)
                let template2 = SingleLandscapeTemplate(photoSizes: [photoSize(followupPhoto)], maxWidth: availableWidth)
                templates.append(template1)
                templates.append(template2)
                photoGroups.append([currentPhoto])
                photoGroups.append([followupPhoto])
                nextIndex += 2
                continue
            } else {
                let template = SideBySideTemplate(photoSizes: [photoSize(currentPhoto), photoSize(followupPhoto)], maxWidth: availableWidth)
                templates.append(template)
                photoGroups.append([currentPhoto, followupPhoto])
                nextIndex += 2
                continue
            }
        }
    }
    
    private func shouldUseSingleLandscapeLayout(photo : PhotoModel) -> Bool {
        let aspectRatio = photo.width / photo.height
        return (aspectRatio >= singleLandscapeAspectRatio)
    }
    
    private func photoSize(photo : PhotoModel) -> CGSize {
        return CGSizeMake(CGFloat(photo.width), CGFloat(photo.height))
    }

}
