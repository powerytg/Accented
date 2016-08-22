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

class DetailViewController: CardViewController, DetailEntranceProxyAnimation, DetailLightBoxAnimation, DetailSectionViewDelegate, UIScrollViewDelegate {

    // Delegate
    weak var delegate : DetailViewControllerDelegate?
    
    // Cache controller
    private var cacheController : DetailCacheController
    
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
                    view.setNeedsLayout()
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
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    
    // Pre-defined width for content
    // This needs to be specified ahead of time because we need to calculate a few things for a precise entrance animation
    private var maxWidth : CGFloat
    
    init(sourceImageView : UIImageView, maxWidth : CGFloat, cacheController : DetailCacheController) {
        self.maxWidth = maxWidth
        self.sourceImageView = sourceImageView
        self.cacheController = cacheController
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
        view.setNeedsLayout()

        // Prepare entrance animation
        setupEntranceAnimationViews()
    }

    private func initializeSections() {
        sectionViews.append(DetailHeaderSectionView(maxWidth: maxWidth, cacheController: cacheController))
        
        self.photoSection = DetailPhotoSectionView(maxWidth: maxWidth, cacheController: cacheController)
        sectionViews.append(photoSection)

        sectionViews.append(DetailDescriptionSectionView(maxWidth: maxWidth, cacheController: cacheController))
        sectionViews.append(DetailMetadataSectionView(maxWidth: maxWidth, cacheController: cacheController))
        sectionViews.append(DetailTagSectionView(maxWidth: maxWidth, cacheController: cacheController))
        sectionViews.append(DetailCommentSectionView(maxWidth: maxWidth, cacheController: cacheController))
        sectionViews.append(DetailEndingSectionView(maxWidth: maxWidth, cacheController: cacheController))
        
        for section in sectionViews {
            section.delegate = self
            contentView.addSubview(section)
        }
        
        // Events
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnPhoto(_:)))
        photoSection.addGestureRecognizer(tap)
        
        let zoom = UIPinchGestureRecognizer(target: self, action: #selector(didPinchOnPhoto(_:)))
        photoSection.addGestureRecognizer(zoom)
    }
    
    // MARK: - Layout
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard photo != nil else { return }
        
        layoutContentView()
    }
    
    private func layoutContentView() {
        var nextY : CGFloat = 0
        for section in sectionViews {
            let cachedHeight = section.estimatedHeight(photo, width: maxWidth)
            section.photo = photo
            section.frame = CGRectMake(0, nextY, maxWidth, cachedHeight)
            nextY += cachedHeight
        }
        
        // Update the content on the scroll view
        scrollView.contentSize = CGSizeMake(maxWidth, nextY)
        scrollView.frame = self.view.bounds
        contentView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)

    }
    
    // MARK: - Entrance animation
    
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
    
    // MARK: - DetailSectionViewDelegate
    
    func sectionViewMeasurementWillChange(section: DetailSectionViewBase) {
        // Remove cached section view measurements
        cacheController.removeSectionMeasurement(section, photoId: section.photo!.photoId)
        
        UIView.animateWithDuration(0.3) { [weak self] in
            self?.layoutContentView()
        }
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
