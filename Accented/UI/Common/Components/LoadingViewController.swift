//
//  LoadingViewController.swift
//  Accented
//
//  Created by Tiangong You on 5/28/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var progressView: UIStackView!
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var retryButton: PushButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingLabel: UILabel!
    
    private let defaultLoadingText = "Loading..."
    private let defaultErrorText = "An error has occurred"
    private let defaultRetryText = "Tap to Retry"
    
    var loadingText : String? {
        didSet {
            view.setNeedsLayout()
        }
    }
    
    var errorText : String? {
        didSet {
            view.setNeedsLayout()
        }
    }
    
    var retryButtonText : String? {
        didSet {
            view.setNeedsLayout()
        }
    }
    
    var retryAction : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Start by showing the loading indicator
        errorView.isHidden = true
        loadingIndicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let loadingText = self.loadingText {
            loadingLabel.text = loadingText
        }
        
        if let errorText = self.errorText {
            errorLabel.text = errorText
        }

        if let retryText = self.retryButtonText {
            retryButton.setTitle(retryText, for: .normal)
        }
    }
    
    func showErrorState() {
        loadingIndicator.stopAnimating()
        errorView.alpha = 0
        errorView.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.errorView.alpha = 1
            self?.progressView.alpha = 0
        }) {  [weak self] (_) in
            self?.progressView.isHidden = true
        }
    }
    
    func showLoadingState() {
        progressView.alpha = 0
        progressView.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.progressView.alpha = 1
            self?.errorView.alpha = 0
        }) {  [weak self] (_) in
            self?.errorView.isHidden = true
            self?.loadingIndicator.startAnimating()
        }
    }
    
    @IBAction func retryButtonDidTap(_ sender: Any) {
        if let retryAction = self.retryAction {
            showLoadingState()
            retryAction()
        }
    }
}
