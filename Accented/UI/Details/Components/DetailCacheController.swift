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
    
    // Comment measurement cache
    private var commentMeasurementCache = [String : CGSize]()
    
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
    
    // Set comment measurement
    func setCommentMeasurement(_ size : CGSize, commentId : String) {
        commentMeasurementCache[commentCacheKey(commentId)] = size
    }
    
    func getCommentMeasurement(_ commentId : String) -> CGSize? {
        return commentMeasurementCache[commentCacheKey(commentId)]
    }
    
    // MARK: Private
    
    private func sectionCacheKey(_ section : DetailSectionViewBase, photoId : String) -> String {
        return "\(section.sectionId)_\(photoId)"
    }
    
    private func tagFramesCacheKey(_ photoId : String) -> String {
        return "tag_frames_\(photoId)"
    }

    private func tagSectionContentSizeCacheKey(_ photoId : String) -> String {
        return "tag_section_size_\(photoId)"
    }

    private func formattedDescriptionTextCache(_ photoId : String) -> String {
        return "desc_\(photoId)"
    }
    
    private func commentCacheKey(_ commentId : String) -> String {
        return "comment_\(commentId)"
    }
    
}
