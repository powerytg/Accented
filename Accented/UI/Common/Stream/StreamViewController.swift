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
    
    var stream:StreamModel?
    let reuseIdentifier = "photoRenderer"
  
    // View model
    private var viewModel : StreamViewModel?
    private var streamState : StreamState {
        return viewModel!.streamState
    }
   
    // Event delegate
    var delegate : StreamViewControllerDelegate?
    
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
        viewModel = StreamViewModel(stream: stream!, collectionView: streamCollectionView, flowLayoutDelegate: self)
        
        streamCollectionView.dataSource = viewModel
        streamCollectionView.delegate = self        

        // Load the first page
        APIService.sharedInstance.getPhotos(StreamType.Popular)
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeMake(CGRectGetWidth(collectionView.bounds), 200)
        } else {
            return CGSizeMake(CGRectGetWidth(collectionView.bounds), 50)
        }
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
        
        if offsetY > contentHeight - scrollView.frame.size.height - 50 {
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
    
}
