//
//  DetailViewController.swift
//  Accented
//
//  Created by Tiangong You on 7/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate : NSObjectProtocol {
    func detailViewDidScroll(offset : CGPoint, contentSize : CGSize)
}

class DetailViewController: CardViewController, DetailEntranceProxyAnimation, UIScrollViewDelegate {

    // Delegate
    weak var delegate : DetailViewControllerDelegate?
    
    private var photoModel : PhotoModel?
    var photo : PhotoModel? {
        get {
            return photoModel
        }
        
        set(value) {
            if photoModel != value {
                photoModel = value
                
                if(isViewLoaded()) {
                    scrollView.contentOffset = CGPointZero
                    updateSectionViews()
                }
            }
        }
    }
    
    // Source image view from entrance transition
    private var sourceImageView : UIImageView
    
    // Sections
    private var sectionViews = [DetailSectionViewBase]()
    
    // All views that would participate entrance animation
    private var entranceAnimationViews = [DetailEntranceAnimation]()
    
    // Cached measurements for all sections
    private var cachedSectionMeasurements = [DetailSectionViewBase : CGRect]()
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    
    // Pre-defined width for content
    // This needs to be specified ahead of time because we need to calculate a few things for a precise entrance animation
    private var maxWidth : CGFloat
    
    init(sourceImageView : UIImageView, maxWidth : CGFloat) {
        self.maxWidth = maxWidth
        self.sourceImageView = sourceImageView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        
        // Setup scroll view and content view
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.addSubview(contentView)
        self.view.addSubview(scrollView)

        initializeSections()
        updateSectionViews()

        // Prepare entrance animation
        setupEntranceAnimationViews()
    }

    private func initializeSections() {
        sectionViews.append(DetailHeaderSectionView(maxWidth: maxWidth))
        sectionViews.append(DetailPhotoSectionView(maxWidth: maxWidth))
        sectionViews.append(DetailDescriptionSectionView(maxWidth: maxWidth))
        sectionViews.append(DetailTagSectionView(maxWidth: maxWidth))
        
        for section in sectionViews {
            contentView.addSubview(section)
        }
    }
    
    private func updateSectionViews() {
        // Clear all previous measurements
        cachedSectionMeasurements.removeAll()
        
        var nextY : CGFloat = 0
        for section in sectionViews {
            section.photo = photo
            let sectionHeight = section.estimatedHeight(maxWidth)
            let sectionFrame = CGRectMake(0, nextY, maxWidth, sectionHeight)
            
            // Cache section measurements
            cachedSectionMeasurements[section] = sectionFrame
            nextY += sectionHeight
        }
        
        scrollView.contentSize = CGSizeMake(maxWidth, nextY)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.frame = self.view.bounds
        contentView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)

        if cachedSectionMeasurements.count > 0 {
            // Sections
            for section in sectionViews {
                section.frame = cachedSectionMeasurements[section]!
            }
        }
    }
    
    private func setupEntranceAnimationViews() {
        for section in sectionViews {
            entranceAnimationViews.append(section)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Animations
    
    func entranceAnimationWillBegin() {
        for view in entranceAnimationViews {
            view.entranceAnimationWillBegin()
        }
    }
    
    func performEntranceAnimation() {
        for view in entranceAnimationViews {
            view.performEntranceAnimation()
        }
    }
    
    func entranceAnimationDidFinish() {
        for view in entranceAnimationViews {
            view.entranceAnimationDidFinish()
        }
    }
    
    func desitinationRectForProxyView(photo: PhotoModel) -> CGRect {
        let headerSection = sectionViews[0] as! DetailHeaderSectionView
        var f = DetailPhotoSectionView.targetRectForPhotoView(photo, width: maxWidth)
        f.origin.y = headerSection.sectionHeight
        return f
    }

    // MARK : - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        delegate?.detailViewDidScroll(scrollView.contentOffset, contentSize: scrollView.contentSize)
    }
    
}
