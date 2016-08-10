//
//  DetailViewController.swift
//  Accented
//
//  Created by Tiangong You on 7/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

// Event delegate for the detail page
protocol DetailViewControllerDelegate : NSObjectProtocol {
    
    // Invoked while the detail page is scrolling. Note that this event will be fired at a very small time interval, similar to UIScrollViewDelegate.scrollViewDidScroll()
    func detailViewDidScroll(offset : CGPoint, contentSize : CGSize)
    
    // Invoked when the user has tapped on the main photo view
    func didTapOnPhoto(photo : PhotoModel, sourceImageView : UIImageView)
    
    // Invoked when the user has started to pinch / zoom on the main photo view
    func didStartPinchOnPhoto(photo : PhotoModel, sourceImageView : UIImageView)
    
    // Invoked when the user has finished to pinch / zoom on the main photo view
    func didEndPinchOnPhoto(photo : PhotoModel, sourceImageView : UIImageView)
    
    // Invoked when the user is pinching on the main photo view
    func photoDidReceivePinch(photo : PhotoModel, sourceImageView : UIImageView, gesture : UIPinchGestureRecognizer)
    
    // Invoked when the user has canceled pinching on the main photo view
    func didCancelPinchOnPhoto(photo: PhotoModel, sourceImageView: UIImageView)
}

class DetailViewController: CardViewController, DetailEntranceProxyAnimation, DetailLightBoxAnimation, UIScrollViewDelegate {

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
    private var photoSection : DetailPhotoSectionView!
    
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
        self.view.clipsToBounds = false
        self.view.backgroundColor = UIColor.clearColor()
        
        // Setup scroll view and content view
        scrollView.clipsToBounds = false
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
        
        self.photoSection = DetailPhotoSectionView(maxWidth: maxWidth)
        sectionViews.append(photoSection)

        sectionViews.append(DetailDescriptionSectionView(maxWidth: maxWidth))
        sectionViews.append(DetailMetadataSectionView(maxWidth: maxWidth))
        sectionViews.append(DetailTagSectionView(maxWidth: maxWidth))
        sectionViews.append(DetailEndingSectionView(maxWidth: maxWidth))
        
        for section in sectionViews {
            contentView.addSubview(section)
        }
        
        // Events
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnPhoto(_:)))
        photoSection.addGestureRecognizer(tap)
        
        let zoom = UIPinchGestureRecognizer(target: self, action: #selector(didPinchOnPhoto(_:)))
        photoSection.addGestureRecognizer(zoom)
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
                if cachedSectionMeasurements[section] != nil {
                    section.frame = cachedSectionMeasurements[section]!
                }                
            }
        }
    }
    
    private func setupEntranceAnimationViews() {
        for section in sectionViews {
            entranceAnimationViews.append(section)
        }
    }
    
    override func performCardTransitionAnimation() {
        super.performCardTransitionAnimation()
        
        for section in sectionViews {
            section.performCardTransitionAnimation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Entrance animation
    
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

    // MARK: - Lightbox animation
    
    func lightBoxTransitionWillBegin() {
        photoSection.lightBoxTransitionWillBegin()
    }
    
    func lightboxTransitionDidFinish() {
        photoSection.lightboxTransitionDidFinish()
    }
    
    func performLightBoxTransition() {
        photoSection.performLightBoxTransition()
    }
    
    func desitinationRectForSelectedLightBoxPhoto(photo: PhotoModel) -> CGRect {
        // No-op
        return CGRectZero
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        delegate?.detailViewDidScroll(scrollView.contentOffset, contentSize: scrollView.contentSize)
    }
    
    // MARK: - Events
    
    @objc private func didTapOnPhoto(gesture : UITapGestureRecognizer) {
        delegate?.didTapOnPhoto(photo!, sourceImageView: photoSection.sourceImageViewForLightBoxTransition())
    }

    @objc private func didPinchOnPhoto(gesture : UIPinchGestureRecognizer) {
        switch gesture.state {
        case .Began:
            delegate?.didStartPinchOnPhoto(photo!, sourceImageView: photoSection.sourceImageViewForLightBoxTransition())
        case .Ended:
            delegate?.didEndPinchOnPhoto(photo!, sourceImageView: photoSection.sourceImageViewForLightBoxTransition())
        case .Cancelled:
            delegate?.didCancelPinchOnPhoto(photo!, sourceImageView: photoSection.sourceImageViewForLightBoxTransition())
        case .Failed:
            delegate?.didCancelPinchOnPhoto(photo!, sourceImageView: photoSection.sourceImageViewForLightBoxTransition())
        case .Changed:
            delegate?.photoDidReceivePinch(photo!, sourceImageView: photoSection.sourceImageViewForLightBoxTransition(), gesture: gesture)
        default: break
        }
    }

    override func cardDidReceivePanGesture(translation: CGFloat, cardWidth: CGFloat) {
        super.cardDidReceivePanGesture(translation, cardWidth: cardWidth)
        for section in sectionViews {
            section.cardDidReceivePanGesture(translation, cardWidth: cardWidth)
        }
    }
    
    override func cardSelectionDidChange(selected: Bool) {
        super.cardSelectionDidChange(selected)
        for section in sectionViews {
            section.cardSelectionDidChange(selected)
        }
        
        // If the card is not selected, reset its scroll offset
        scrollView.setContentOffset(CGPointZero, animated: true)
    }
}
