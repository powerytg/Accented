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
    weak var streamViewModel : StreamViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // By default, hide the ending symbol and the retry button
        retryButton.hidden = true
        endingView.hidden = true
    }
    
    func showRetryState() {
        loadingView.stopLoadingAnimation()
        loadingView.hidden = true
        endingView.hidden = true
        retryButton.hidden = false
    }
    
    func showLoadingState() {
        loadingView.startLoadingAnimation()
        loadingView.hidden = false
        endingView.hidden = true
        retryButton.hidden = true
    }
    
    func showEndingState() {
        loadingView.stopLoadingAnimation()
        loadingView.hidden = true
        endingView.hidden = false
        retryButton.hidden = true
    }

    @IBAction func retryButtonDidTouch(sender: AnyObject) {
        showLoadingState()
        
        if let viewModel = streamViewModel {
            viewModel.loadNextPage()
        }
    }
}
