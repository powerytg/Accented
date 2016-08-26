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
    private var tagButtonFrameCache = [String : [CGRect]]()
    
    // Cached tag section content size
    private var tagSectionContentSizeCache = [String : CGSize]()
    
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
    
    // Set a list of tag frames for photo
    func setTagButtonFrames(frames : [CGRect], photoId : String) {
        let key = tagFramesCacheKey(photoId)
        tagButtonFrameCache[key] = frames
    }

    // Get cached tag button frames for the photo
    func getTagButtonFrames(photoId : String) -> [CGRect]? {
        let key = tagFramesCacheKey(photoId)
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
    
    // Set a cached size for the tag section content
    func setTagSectionContentSize(size : CGSize, photoId : String) {
        tagSectionContentSizeCache[tagSectionContentSizeCacheKey(photoId)] = size
    }
    
    // Set the cached size for the tag section content
    func getTagSectionContentSize(photoId : String) -> CGSize? {
        return tagSectionContentSizeCache[tagSectionContentSizeCacheKey(photoId)]
    }
    
    // MARK: Private
    
    private func sectionCacheKey(section : DetailSectionViewBase, photoId : String) -> String {
        return "\(section.sectionId)_\(photoId)"
    }
    
    private func tagFramesCacheKey(photoId : String) -> String {
        return "tag_frames_\(photoId)"
    }

    private func tagSectionContentSizeCacheKey(photoId : String) -> String {
        return "tag_section_size_\(photoId)"
    }

    private func formattedDescriptionTextCache(photoId : String) -> String {
        return "desc_\(photoId)"
    }
}
