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
    fileprivate var sectionMeasurementCache = [String : CGFloat]()
    
    // Cached tag button frames
    // The key is a combination of photo id and tag index in the photo, which should be calculated with the tagButtonCacheKey() method
    // The value is the cached frame for the tag
    fileprivate var tagButtonFrameCache = [String : [CGRect]]()
    
    // Cached tag section content size
    fileprivate var tagSectionContentSizeCache = [String : CGSize]()
    
    // Formatted text cache
    fileprivate var formattedTextCache = [String : NSAttributedString]()
    
    // Set a cached measurement for the section for the specific photo
    func setSectionMeasurement(_ height : CGFloat, section : DetailSectionViewBase, photoId : String) {
        let key = sectionCacheKey(section, photoId: photoId)
        sectionMeasurementCache[key] = height
    }

    // Get a cached measurement for the section for the specific photo
    func getSectionMeasurement(_ section : DetailSectionViewBase, photoId : String) -> CGFloat? {
        let key = sectionCacheKey(section, photoId: photoId)
        return sectionMeasurementCache[key]
    }

    // Clear the cached measurement for the section for the specific photo
    func removeSectionMeasurement(_ section : DetailSectionViewBase, photoId : String) {
        let key = sectionCacheKey(section, photoId: photoId)
        sectionMeasurementCache.removeValue(forKey: key)
    }
    
    // Set a list of tag frames for photo
    func setTagButtonFrames(_ frames : [CGRect], photoId : String) {
        let key = tagFramesCacheKey(photoId)
        tagButtonFrameCache[key] = frames
    }

    // Get cached tag button frames for the photo
    func getTagButtonFrames(_ photoId : String) -> [CGRect]? {
        let key = tagFramesCacheKey(photoId)
        return tagButtonFrameCache[key]
    }

    func setFormattedDescription(_ desc : NSAttributedString, photoId : String) {
        let key = formattedDescriptionTextCache(photoId)
        formattedTextCache[key] = desc
    }
    
    func getFormattedDescription(_ photoId : String) -> NSAttributedString? {
        let key = formattedDescriptionTextCache(photoId)
        return formattedTextCache[key]
    }
    
    // Set a cached size for the tag section content
    func setTagSectionContentSize(_ size : CGSize, photoId : String) {
        tagSectionContentSizeCache[tagSectionContentSizeCacheKey(photoId)] = size
    }
    
    // Set the cached size for the tag section content
    func getTagSectionContentSize(_ photoId : String) -> CGSize? {
        return tagSectionContentSizeCache[tagSectionContentSizeCacheKey(photoId)]
    }
    
    // MARK: Private
    
    fileprivate func sectionCacheKey(_ section : DetailSectionViewBase, photoId : String) -> String {
        return "\(section.sectionId)_\(photoId)"
    }
    
    fileprivate func tagFramesCacheKey(_ photoId : String) -> String {
        return "tag_frames_\(photoId)"
    }

    fileprivate func tagSectionContentSizeCacheKey(_ photoId : String) -> String {
        return "tag_section_size_\(photoId)"
    }

    fileprivate func formattedDescriptionTextCache(_ photoId : String) -> String {
        return "desc_\(photoId)"
    }
}
