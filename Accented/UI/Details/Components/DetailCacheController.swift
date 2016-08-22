//
//  DetailCacheController.swift
//  Accented
//
//  Created by Tiangong You on 8/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailCacheController: NSObject {
    
    // Section height cache
    // The key is a combination of section id and photo id, which should be calculated with the sectionCacheKey() method
    // The value is the cached height for the section with the photo
    private var sectionMeasurementCache = [String : CGFloat]()
    
    // Cached tag button frames
    // The key is a combination of photo id and tag index in the photo, which should be calculated with the tagButtonCacheKey() method
    // The value is the cached frame for the tag
    private var tagButtonFrameCache = [String : CGRect]()
    
    // Formatted text cache
    private var formattedTextCache = [String : NSAttributedString]()
    
    // Set a cached measurement for the section for the specific photo
    func setSectionMeasurement(height : CGFloat, section : DetailSectionViewBase, photoId : String) {
        let key = sectionCacheKey(section, photoId: photoId)
        sectionMeasurementCache[key] = height
    }

    // Get a cached measurement for the section for the specific photo
    func getSectionMeasurement(section : DetailSectionViewBase, photoId : String) -> CGFloat? {
        let key = sectionCacheKey(section, photoId: photoId)
        return sectionMeasurementCache[key]
    }

    // Clear the cached measurement for the section for the specific photo
    func removeSectionMeasurement(section : DetailSectionViewBase, photoId : String) {
        let key = sectionCacheKey(section, photoId: photoId)
        sectionMeasurementCache.removeValueForKey(key)
    }
    
    // Set a cached frame for the tag in the specific photo
    func setTagButtonFrame(frame: CGRect, photoId : String, tagIndex : Int) {
        let key = tagButtonCacheKey(photoId, tagIndex: tagIndex)
        tagButtonFrameCache[key] = frame
    }

    // Get a cached measurement for the section for the specific photo
    func getTagButtonFrame(photoId : String, tagIndex : Int) -> CGRect? {
        let key = tagButtonCacheKey(photoId, tagIndex : tagIndex)
        return tagButtonFrameCache[key]
    }

    func setFormattedDescription(desc : NSAttributedString, photoId : String) {
        let key = formattedDescriptionTextCache(photoId)
        formattedTextCache[key] = desc
    }
    
    func getFormattedDescription(photoId : String) -> NSAttributedString? {
        let key = formattedDescriptionTextCache(photoId)
        return formattedTextCache[key]
    }
    
    // MARK: Private
    
    private func sectionCacheKey(section : DetailSectionViewBase, photoId : String) -> String {
        return "\(section.sectionId)_\(photoId)"
    }
    
    private func tagButtonCacheKey(photoId : String, tagIndex : Int) -> String {
        return "tag_\(photoId)_\(tagIndex)"
    }
    
    private func formattedDescriptionTextCache(photoId : String) -> String {
        return "desc_\(photoId)"
    }
}
