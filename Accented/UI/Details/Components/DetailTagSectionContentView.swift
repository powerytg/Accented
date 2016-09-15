//
//  DetailTagSectionContentView.swift
//  Accented
//
//  Created by You, Tiangong on 8/25/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailTagSectionContentView: UIView, UIGestureRecognizerDelegate {

    fileprivate let hGap : CGFloat = 6
    fileprivate let vGap : CGFloat = 6
    fileprivate let tagButtonInset = UIEdgeInsetsMake(4, 8, 4, 8)
    fileprivate let tagButtonBackground = UIColor(red: 32 / 255.0, green: 32 / 255.0, blue: 32 / 255.0, alpha: 1)
    fileprivate let tagButtonActiveBackground = UIColor(red: 128 / 255.0, green: 128 / 255.0, blue: 128 / 255.0, alpha: 0.5)
    fileprivate let tagButtonBorderColor = UIColor.black
    fileprivate let tagButtonRadius : CGFloat = 4
    fileprivate let tagButtonFont = UIFont(name: "AvenirNextCondensed-Medium", size: 15)!
    fileprivate var tagButtonAttrs : [String : AnyObject]!

    // Photo model
    var photoModel : PhotoModel?
    var photo : PhotoModel? {
        get {
            return photoModel
        }
        
        set(value) {
            if photoModel != value {
                photoModel = value
                photoModelDidChange()
            }
        }
    }
    
    // The rect of tag that currently being tapped upon
    fileprivate var activeTagFrame : CGRect?
    fileprivate var activeTagIndex : Int?
    
    // Cached tag button frames
    fileprivate var tagButtonFrames : [CGRect]?

    // Cached content view size
    fileprivate var contentViewSize : CGSize?

    // Cached tag images
    fileprivate var cachedContentImage : UIImage?
    
    // Passed through cache controller
    var cacheController : DetailCacheController!
    
    override init(frame: CGRect) {
        // Tag button drawing attributes
        tagButtonAttrs = [NSFontAttributeName : tagButtonFont, NSForegroundColorAttributeName : UIColor.white]
        super.init(frame: frame)
        
        // Use a long press recoginzer instead of tap recoginzer, because we want to capture the touchBegin state
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(didTapOnContentView(_:)))
        tap.minimumPressDuration = 0
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func photoModelDidChange() {
        if photo!.tags.count > 0 {
            // Retrieve content view size and tag button frames from cache
            tagButtonFrames = cacheController.getTagButtonFrames(photo!.photoId)
            contentViewSize = cacheController.getTagSectionContentSize(photo!.photoId)
            
            // Use a background thread to render the tag buttons
            renderTagButtonsOnBackground()
        } else {
            tagButtonFrames = nil
            contentViewSize = nil
        }
    }
    
    // MARK: - Measurements
    
    func contentViewHeightForPhoto(_ photo: PhotoModel, width: CGFloat) -> CGFloat {
        // Estimiate the content image size, as well as invidual tag button frames
        tagButtonFrames = [CGRect]()
        var nextX : CGFloat = 0
        var nextY : CGFloat = 0
        var maxRowHeight : CGFloat = 0
        var calculatedSectionHeight : CGFloat = 0
        let maxBounds = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        for tag in photo.tags {
            let textSize = NSString(string: tag).boundingRect(with: maxBounds, options: .usesLineFragmentOrigin, attributes: tagButtonAttrs, context: nil)
            
            // Apply the inset to the measured text size. This will be the frame for the tag button
            var f = CGRect(x: 0, y: 0, width: textSize.width + tagButtonInset.left + tagButtonInset.right, height: textSize.height + tagButtonInset.top + tagButtonInset.bottom)
            
            if f.height > maxRowHeight {
                maxRowHeight = f.height
            }
            
            if nextX + f.width > width {
                // Start a new row
                nextX = 0
                nextY += maxRowHeight + vGap
                maxRowHeight = f.height
                f.origin.x = nextX
                f.origin.y = nextY
                nextX += f.width + hGap
            } else {
                // Put the button to the right of its sibling
                f.origin.x = nextX
                f.origin.y = nextY
                nextX += f.width + hGap
            }
            
            // Cache the frame for the tag button
            tagButtonFrames!.append(f)
            calculatedSectionHeight = nextY + maxRowHeight
        }
        
        // Cached the size of the content view
        contentViewSize = CGSize(width: width, height: calculatedSectionHeight)
        cacheController.setTagSectionContentSize(contentViewSize!, photoId: photo.photoId)
        cacheController.setTagButtonFrames(tagButtonFrames!, photoId: photo.photoId)
        
        return calculatedSectionHeight
    }
    
    // MARK : - Rendering
    
    override func draw(_ rect: CGRect) {
        guard cachedContentImage != nil else { return  }
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        ctx?.clear(self.bounds)
        
        // Draw the original tag images
        cachedContentImage?.draw(in: rect)
        
        // Draw a highlighted rounded rect for the active tag button
        if activeTagFrame != nil {
            let path = UIBezierPath(roundedRect: activeTagFrame!, cornerRadius: tagButtonRadius)
            path.lineWidth = 1
            self.tagButtonActiveBackground.setFill()
            self.tagButtonBorderColor.setStroke()
            path.fill()
            path.stroke()
        }
        
        ctx?.restoreGState()
    }

    fileprivate func renderTagButtonsOnBackground() {
        let cacheKey = cachedContentViewImageKey
        guard cacheKey != nil else { return }
        let cachedEntry = RenderService.sharedInstance.getCachedImage(cacheKey!)
        guard cachedEntry.identifier == cacheKey else { return }
        
        if cachedEntry.cachedImage != nil {
            cachedContentImage = cachedEntry.cachedImage!
            self.setNeedsDisplay()
        } else {
            let tags = photo!.tags
            let imageSize = contentViewSize
            let tagFrames = tagButtonFrames
            
            guard imageSize != nil else { return }
            guard tagFrames != nil else { return }
            guard tags.count == tagButtonFrames!.count else { return }
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                let renderedImage = self?.renderTagButtonsToImage(imageSize!, tags: tags, tagFrames: tagFrames!)
                guard renderedImage != nil else { return }
                
                DispatchQueue.main.async(execute: {
                    self?.cachedContentImage = renderedImage
                    self?.setNeedsDisplay()
                    RenderService.sharedInstance.setCachedImage(cacheKey!, image: renderedImage!)
                })
                
            }
        }
    }
    
    fileprivate func renderTagButtonsToImage(_ imageSize : CGSize, tags : [String], tagFrames : [CGRect]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        
        for (index, tag) in tags.enumerated() {
            let tagFrame = tagFrames[index]
            
            // Draw a rounded rect
            let path = UIBezierPath(roundedRect: tagFrame, cornerRadius: tagButtonRadius)
            path.lineWidth = 1
            self.tagButtonBackground.setFill()
            self.tagButtonBorderColor.setStroke()
            path.fill()
            path.stroke()
            
            // Draw tag text
            var textRect = tagFrame
            textRect.origin.x += tagButtonInset.left
            textRect.origin.y += tagButtonInset.top
            NSString(string: tag).draw(in: textRect, withAttributes: tagButtonAttrs)
        }
        
        let renderedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return renderedImage!
    }
    
    // MARK: - Events
    
    @objc func didTapOnContentView(_ tap : UILongPressGestureRecognizer) {
        switch tap.state {
        case .began:
            let activeTagInfo = getActiveTagInfo(tap.location(in: self))
            activeTagFrame = activeTagInfo.rect
            activeTagIndex = activeTagInfo.tagIndex
            if activeTagFrame != nil {
                setNeedsDisplay()
            }
        case .ended:
            activeTagFrame = nil
            activeTagIndex = nil
            setNeedsDisplay()
        case .cancelled:
            activeTagFrame = nil
            activeTagIndex = nil
            setNeedsDisplay()
        default:
            break
        }
        
    }
    
    fileprivate func getActiveTagInfo(_ point : CGPoint) -> (tagIndex : Int?, rect: CGRect?) {
        guard tagButtonFrames != nil else { return (tagIndex : nil, rect : nil) }
        for (index, rect) in tagButtonFrames!.enumerated() {
            if rect.contains(point) {
                return (tagIndex : index, rect : rect)
            }
        }
        
        return (tagIndex : nil, rect : nil)
    }

    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - Private
    
    fileprivate var cachedContentViewImageKey : String? {
        return (photo == nil ? nil : "tag_image_\(photo!.photoId)")
    }

}
