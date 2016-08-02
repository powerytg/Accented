//
//  DetailViewController.swift
//  Accented
//
//  Created by Tiangong You on 7/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, DetailEntranceProxyAnimation {

    var photo : PhotoModel
    var sourceImageView : UIImageView
    var sectionViews = [DetailSectionViewBase]()
    var entranceAnimationViews = [DetailEntranceAnimation]()
    var cachedSectionMeasurements = [DetailSectionViewBase : CGRect]()
    
    var backgroundView: DetailBackgroundView
    var scrollView: UIScrollView
    
    init(photo : PhotoModel, sourceImageView : UIImageView) {
        self.photo = photo
        self.sourceImageView = sourceImageView
        self.backgroundView = DetailBackgroundView(frame: CGRectZero)
        self.scrollView = UIScrollView(frame: CGRectZero)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(backgroundView)
        self.view.addSubview(scrollView)
        
        setupSections()
        setupEntranceAnimationViews()
    }

    private func setupSections() {
        let contentView = UIView()
        scrollView.addSubview(contentView)
        
        let w = CGRectGetWidth(UIScreen.mainScreen().bounds)
        sectionViews.append(DetailOverviewSectionView(photo: photo, maxWidth: w))
        sectionViews.append(DetailDescriptionSectionView(photo: photo, maxWidth: w))
        
        var nextY : CGFloat = 0
        for section in sectionViews {
            let sectionHeight = section.estimatedHeight(w)
            let sectionFrame = CGRectMake(0, nextY, w, sectionHeight)
            section.frame = sectionFrame
            contentView.addSubview(section)
            
            // Cache section measurements
            cachedSectionMeasurements[section] = sectionFrame
            
            nextY += sectionHeight
        }
        
        contentView.frame = CGRectMake(0, 0, w, nextY)
        scrollView.contentSize = CGSizeMake(w, nextY)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        backgroundView.frame = self.view.bounds
        scrollView.frame = self.view.bounds
        
        for section in sectionViews {
            section.frame = cachedSectionMeasurements[section]!
        }
    }
    
    private func setupEntranceAnimationViews() {
        entranceAnimationViews.append(backgroundView)
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
        return DetailOverviewSectionView.targetRectForPhotoView(photo)
    }
    
}
