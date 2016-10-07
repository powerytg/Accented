//
//  StreamViewController.swift
//  Accented
//
//  Created by Tiangong You on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamViewController: UIViewController, UICollectionViewDelegateFlowLayout, StreamViewModelDelegate {

    @IBOutlet weak var streamCollectionView: UICollectionView!
    
    // Refresh header
    fileprivate var refreshHeaderView = RefreshHeaderView()
    
    // Refresh header compression percentage
    fileprivate var refreshHeaderCompressionRatio : CGFloat = 0
    
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName : "StreamViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear
        streamCollectionView.backgroundColor = UIColor.clear

        // Create the stream view model
        createViewModel()
        viewModel?.delegate = self
        streamCollectionView.dataSource = viewModel
        streamCollectionView.delegate = self
        
        // Create a refresh header
        view.addSubview(refreshHeaderView)
        refreshHeaderView.alpha = 0
        
        // Refresh stream
        if let streamModel = stream {
            if !streamModel.loaded {
                viewModel!.loadNextPage()
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var f = refreshHeaderView.frame
        f.size.width = view.bounds.size.width
        f.size.height = RefreshHeaderView.maxHeight
        refreshHeaderView.frame = f
    }
    
    func createViewModel() {
        fatalError("Not implemented in base class")
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    // MARK: - Infinite scrolling
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        streamState.scrolling = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshHeaderCompressionRatio == 1 {
            viewModel?.refresh()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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
        let visibleIndexes = streamCollectionView.indexPathsForVisibleItems
        if visibleIndexes.count > 0 {
            let firstVisibleIndex = visibleIndexes[0]
            let firstVisiblePhoto = stream!.photos[firstVisibleIndex.item]
            delegate?.streamViewDidFinishedScrolling(firstVisiblePhoto)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !streamState.refreshing {
            refreshHeaderCompressionRatio = max(0, min(1, -scrollView.contentOffset.y / RefreshHeaderView.maxTravelDistance))
            refreshHeaderView.transform = CGAffineTransform(scaleX: refreshHeaderCompressionRatio, y: 1)
            refreshHeaderView.alpha = refreshHeaderCompressionRatio
        }
        
        delegate?.streamViewContentOffsetDidChange(streamCollectionView.contentOffset.y)
    }
    
    // MARK : - StreamViewModelDelegate
    
    func viewModelDidRefresh() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.refreshHeaderView.alpha = 0
        }
    }
}
