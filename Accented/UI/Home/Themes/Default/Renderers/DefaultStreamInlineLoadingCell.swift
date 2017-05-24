//
//  StreamLoadingCell.swift
//  Accented
//
//  Created by You, Tiangong on 5/4/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DefaultStreamInlineLoadingCell: UICollectionViewCell {

    @IBOutlet weak var loadingView: InlineLoadingView!    
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var endingView: UIImageView!
    
    // Reference to the stream view model
    weak var streamViewModel : InfiniteLoadingViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // By default, hide the ending symbol and the retry button
        retryButton.isHidden = true
        endingView.isHidden = true
    }
    
    func showRetryState() {
        loadingView.stopLoadingAnimation()
        loadingView.isHidden = true
        endingView.isHidden = true
        retryButton.isHidden = false
    }
    
    func showLoadingState() {
        loadingView.startLoadingAnimation()
        loadingView.isHidden = false
        endingView.isHidden = true
        retryButton.isHidden = true
    }
    
    func showEndingState() {
        loadingView.stopLoadingAnimation()
        loadingView.isHidden = true
        endingView.isHidden = false
        retryButton.isHidden = true
    }

    @IBAction func retryButtonDidTouch(_ sender: AnyObject) {
        showLoadingState()
        
        if let viewModel = streamViewModel {
            viewModel.loadNextPage()
        }
    }
}
