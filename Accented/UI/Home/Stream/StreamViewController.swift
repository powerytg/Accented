//
//  StreamViewController.swift
//  Accented
//
//  Created by Tiangong You on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamViewController: InfiniteLoadingViewController {

    // View model
    var stream:StreamModel? {
        didSet {
            if stream != nil && viewModel != nil {
                streamViewModel!.stream = stream!
                streamViewModel!.loadStreamIfNecessary()
            }
        }
    }
    
    var streamViewModel : StreamViewModel? {
        return viewModel as? StreamViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Refresh stream
        if let streamModel = stream {
            if !streamModel.loaded {
                viewModel!.loadNextPage()
            }
        }
    }
}
