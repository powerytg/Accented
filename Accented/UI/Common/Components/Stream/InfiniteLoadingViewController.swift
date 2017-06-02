//
//  InfiniteLoadingViewController.swift
//  Accented
//
//  Created by You, Tiangong on 10/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class InfiniteLoadingViewController<T : ModelBase>: UIViewController, UICollectionViewDelegateFlowLayout, InfiniteLoadingViewModelDelegate {

    var collectionView : UICollectionView!
    
    // Refresh header
    fileprivate var refreshHeaderView = RefreshHeaderView()
    
    // Refresh header compression percentage
    fileprivate var refreshHeaderCompressionRatio : CGFloat = 0
    
    // Infinite scrolling threshold
    let loadingThreshold : CGFloat = 50
    
    // Placeholder view in case the collection has no content
    var noContentLabel = UILabel()
    
    // View model
    var viewModel : InfiniteLoadingViewModel<T>?
    var streamState : StreamState {
        return viewModel!.streamState
    }

    // Event delegate
    weak var delegate : InfiniteLoadingViewControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup a no-content label
        noContentLabel.isHidden = true
        noContentLabel.text = "No content available"
        noContentLabel.textColor = ThemeManager.sharedInstance.currentTheme.descTextColor
        noContentLabel.font = ThemeManager.sharedInstance.currentTheme.descFont
        view.addSubview(noContentLabel)
        noContentLabel.sizeToFit()
        
        // Setup collection view
        self.view.backgroundColor = UIColor.clear
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.clear
        view.addSubview(collectionView)
        
        // Create the stream view model
        createViewModel()
        viewModel?.delegate = self
        collectionView.dataSource = viewModel
        collectionView.delegate = self

        // Create a refresh header
        view.addSubview(refreshHeaderView)
        refreshHeaderView.alpha = 0
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Reset the stream state
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createViewModel() {
        fatalError("Not implemented in base class")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Refresh header
        var f = refreshHeaderView.frame
        f.origin.x = 0
        f.origin.y = 0
        f.size.width = view.bounds.size.width
        f.size.height = RefreshHeaderView.maxHeight
        refreshHeaderView.frame = f

        // Collection view
        collectionView.frame = view.bounds
        
        // Center the no-content label
        f = noContentLabel.frame
        f.origin.x = view.bounds.width / 2 - f.size.width / 2
        f.origin.y = view.bounds.height / 2 - f.size.height / 2
        noContentLabel.frame = f
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
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height - loadingThreshold {
            viewModel!.loadNextPage()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !streamState.refreshing {
            // CGAffineTransform.scale doesn't work with value 0, so using a small number to simulate the effect
            refreshHeaderCompressionRatio = max(0.001, min(1, -scrollView.contentOffset.y / RefreshHeaderView.maxTravelDistance))
            refreshHeaderView.transform = CGAffineTransform(scaleX: refreshHeaderCompressionRatio, y: 1)
            refreshHeaderView.alpha = refreshHeaderCompressionRatio
        }
        
        delegate?.collectionViewContentOffsetDidChange(collectionView.contentOffset.y)
    }
    
    // MARK : - StreamViewModelDelegate
    
    func viewModelDidRefresh() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.refreshHeaderView.alpha = 0
        }
    }
    
    func viewModelDidUpdate() {
        if viewModel?.collection.totalCount == 0 {
            collectionView.isHidden = true
            noContentLabel.isHidden = false
        } else {
            collectionView.isHidden = false
            noContentLabel.isHidden = true
        }
    }
}
