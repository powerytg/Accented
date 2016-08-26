//
//  DetailTagSectionContentView.swift
//  Accented
//
//  Created by You, Tiangong on 8/25/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailTagSectionContentView: UIView {

    private let hGap : CGFloat = 6
    private let vGap : CGFloat = 6
    private let tagButtonInset = UIEdgeInsetsMake(4, 8, 4, 8)
    private let tagButtonBackground = UIColor(red: 32 / 255.0, green: 32 / 255.0, blue: 32 / 255.0, alpha: 1)
    private let tagButtonActiveBackground = UIColor(red: 128 / 255.0, green: 128 / 255.0, blue: 128 / 255.0, alpha: 0.5)
    private let tagButtonBorderColor = UIColor.blackColor()
    private let tagButtonRadius : CGFloat = 4
    private let tagButtonFont = UIFont(name: "AvenirNextCondensed-Medium", size: 15)!
    private var tagButtonAttrs : [String : AnyObject]!

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
    private var activeTagFrame : CGRect?
    private var activeTagIndex : Int?
    
    // Cached tag button frames
    private var tagButtonFrames : [CGRect]?

    // Cached content view size
    private var contentViewSize : CGSize?

    // Cached tag images
    private var cachedContentImage : UIImage?
    
    // Passed through cache controller
    var cacheController : DetailCacheController!
    
    override init(frame: CGRect) {
        // Tag button drawing attributes
        tagButtonAttrs = [NSFontAttributeName : tagButtonFont, NSForegroundColorAttributeName : UIColor.whiteColor()]
        super.init(frame: frame)
        
        // Use a long press recoginzer instead of tap recoginzer, because we want to capture the touchBegin state
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(didTapOnContentView(_:)))
        tap.minimumPressDuration = 0
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func photoModelDidChange() {
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
    
    func contentViewHeightForPhoto(photo: PhotoModel, width: CGFloat) -> CGFloat {
        // Estimiate the content image size, as well as invidual tag button frames
        tagButtonFrames = [CGRect]()
        var nextX : CGFloat = 0
        var nextY : CGFloat = 0
        var maxRowHeight : CGFloat = 0
        var calculatedSectionHeight : CGFloat = 0
        let maxBounds = CGSizeMake(width, CGFloat.max)
        
        for tag in photo.tags {
            let textSize = NSString(string: tag).boundingRectWithSize(maxBounds, options: .UsesLineFragmentOrigin, attributes: tagButtonAttrs, context: nil)
            
            // Apply the inset to the measured text size. This will be the frame for the tag button
            var f = CGRectMake(0, 0, textSize.width + tagButtonInset.left + tagButtonInset.right, textSize.height + tagButtonInset.top + tagButtonInset.bottom)
            
            if CGRectGetHeight(f) > maxRowHeight {
                maxRowHeight = CGRectGetHeight(f)
            }
            
            if nextX + CGRectGetWidth(f) > width {
                // Start a new row
                nextX = 0
                nextY += maxRowHeight + vGap
                maxRowHeight = CGRectGetHeight(f)
                f.origin.x = nextX
                f.origin.y = nextY
                nextX += CGRectGetWidth(f) + hGap
            } else {
                // Put the button to the right of its sibling
                f.origin.x = nextX
                f.origin.y = nextY
                nextX += CGRectGetWidth(f) + hGap
            }
            
            // Cache the frame for the tag button
            tagButtonFrames!.append(f)
            calculatedSectionHeight = nextY + maxRowHeight
        }
        
        // Cached the size of the content view
        contentViewSize = CGSizeMake(width, calculatedSectionHeight)
        cacheController.setTagSectionContentSize(contentViewSize!, photoId: photo.photoId)
        cacheController.setTagButtonFrames(tagButtonFrames!, photoId: photo.photoId)
        
        return calculatedSectionHeight
    }
    
    // MARK : - Rendering
    
    override func drawRect(rect: CGRect) {
        guard cachedContentImage != nil else { return  }
        
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        CGContextClearRect(ctx, self.bounds)
        
        // Draw the original tag images
        cachedContentImage?.drawInRect(rect)
        
        // Draw a highlighted rounded rect for the active tag button
        if activeTagFrame != nil {
            let path = UIBezierPath(roundedRect: activeTagFrame!, cornerRadius: tagButtonRadius)
            path.lineWidth = 1
            self.tagButtonActiveBackground.setFill()
            self.tagButtonBorderColor.setStroke()
            path.fill()
            path.stroke()
        }
        
        CGContextRestoreGState(ctx)
    }

    private func renderTagButtonsOnBackground() {
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
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { [weak self] in
                let renderedImage = self?.renderTagButtonsToImage(imageSize!, tags: tags, tagFrames: tagFrames!)
                guard renderedImage != nil else { return }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self?.cachedContentImage = renderedImage
                    self?.setNeedsDisplay()
                    RenderService.sharedInstance.setCachedImage(cacheKey!, image: renderedImage!)
                })
                
            }
        }
    }
    
    private func renderTagButtonsToImage(imageSize : CGSize, tags : [String], tagFrames : [CGRect]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        
        for (index, tag) in tags.enumerate() {
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
            NSString(string: tag).drawInRect(textRect, withAttributes: tagButtonAttrs)
        }
        
        let renderedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return renderedImage
    }
    
    // MARK: - Events
    
    @objc func didTapOnContentView(tap : UILongPressGestureRecognizer) {
        switch tap.state {
        case .Began:
            let activeTagInfo = getActiveTagInfo(tap.locationInView(self))
            activeTagFrame = activeTagInfo.rect
            activeTagIndex = activeTagInfo.tagIndex
            if activeTagFrame != nil {
                setNeedsDisplay()
            }
        case .Ended:
            activeTagFrame = nil
            activeTagIndex = nil
            setNeedsDisplay()
        case .Cancelled:
            activeTagFrame = nil
            activeTagIndex = nil
            setNeedsDisplay()
        default:
            break
        }
        
    }
    
    private func getActiveTagInfo(point : CGPoint) -> (tagIndex : Int?, rect: CGRect?) {
        guard tagButtonFrames != nil else { return (tagIndex : nil, rect : nil) }
        for (index, rect) in tagButtonFrames!.enumerate() {
            if CGRectContainsPoint(rect, point) {
                return (tagIndex : index, rect : rect)
            }
        }
        
        return (tagIndex : nil, rect : nil)
    }
    
    // MARK: - Private
    
    private var cachedContentViewImageKey : String? {
        return (photo == nil ? nil : "tag_image_\(photo!.photoId)")
    }

}
