//
//  StreamInitialLoadingCell.swift
//  Accented
//
//  Created by You, Tiangong on 5/4/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DefaultStreamInitialLoadingCell: UICollectionViewCell {

    @IBOutlet weak var loadingIndicator: InlineLoadingView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var retryButton: PushButton!
    
    private let duration = 0.2
    
    // Reference to the stream view model
    weak var streamViewModel : StreamViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // By default, hide the ending symbol and the retry button
        retryButton.alpha = 0
        messageLabel.alpha = 0
        loadingIndicator.loadingIndicator.image = UIImage(named: "DarkLoadingIndicatorLarge")
    }
    
    func showRetryState(_ errorMessage : String) {
        loadingIndicator.stopLoadingAnimation()
        messageLabel.text = errorMessage
        
        UIView.animate(withDuration: duration) { [weak self] in
            self?.loadingIndicator.alpha = 0
            self?.messageLabel.alpha = 1
            self?.retryButton.alpha = 1
        }
    }
    
    func showLoadingState() {
        loadingIndicator.startLoadingAnimation()
        UIView.animate(withDuration: duration) { [weak self] in
            self?.loadingIndicator.alpha = 1
            self?.messageLabel.alpha = 0
            self?.retryButton.alpha = 0
        }
    }
    
    @IBAction func retryButtonDidTouch(_ sender: AnyObject) {
        showLoadingState()
        
        if let viewModel = streamViewModel {
            viewModel.loadNextPage()
        }
    }

}
