//
//  StreamViewController.swift
//  Accented
//
//  Created by Tiangong You on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var streamCollectionView: UICollectionView!
    
    // Infinite scrolling threshold
    let loadingThreshold : CGFloat = 50
    
    // View model
    var stream:StreamModel? {
        didSet {
            if stream != nil && viewModel != nil {
                viewModel!.stream = stream!
                viewModel!.loadStreamIfNecessary()
            }
        }
    }
    
    var viewModel : StreamViewModel?
    var streamState : StreamState {
        return viewModel!.streamState
    }
   
    // Event delegate
    weak var delegate : StreamViewControllerDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName : "StreamViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clearColor()
        streamCollectionView.backgroundColor = UIColor.clearColor()

        // Create the stream view model
        createViewModel()
        
        streamCollectionView.dataSource = viewModel
        streamCollectionView.delegate = self
        
        // Refresh stream
        if let streamModel = stream {
            if !streamModel.loaded {
                viewModel!.loadNextPage()
            }
        }
    }

    func createViewModel() {
        fatalError("Not implemented in base class")
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    // MARK: - Infinite scrolling
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        streamState.scrolling = true
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        streamState.scrolling = false
        
        if streamState.dirty {
            streamState.dirty = false
            viewModel?.updateCollectionView(false)
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height - loadingThreshold {
            viewModel!.loadNextPage()
        }
        
        // Dispatch events
        let visibleIndexes = streamCollectionView.indexPathsForVisibleItems()
        if visibleIndexes.count > 0 {
            let firstVisibleIndex = visibleIndexes[0]
            let firstVisiblePhoto = stream!.photos[firstVisibleIndex.item]
            delegate?.streamViewDidFinishedScrolling(firstVisiblePhoto)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        delegate?.streamViewContentOffsetDidChange(streamCollectionView.contentOffset.y)
    }
}
