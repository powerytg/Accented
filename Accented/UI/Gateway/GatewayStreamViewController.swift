//
//  GatewayStreamViewController.swift
//  Accented
//
//  Created by Tiangong You on 5/2/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class GatewayStreamViewController: StreamViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(streamDidUpdate(_:)), name: StorageServiceEvents.streamDidUpdate, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func createViewModel() {
        // If the stream has no content, create a loading view model
        if !stream!.loaded {
            viewModel = GatewayInitialLoadingViewModel(stream: stream!, collectionView: streamCollectionView, flowLayoutDelegate: self)
        } else {
            viewModel = GatewayViewModel(stream: stream!, collectionView: streamCollectionView, flowLayoutDelegate: self)
        }        
    }
    
    // MARK: - Events
    func streamDidUpdate(notification : NSNotification) -> Void {
        let streamTypeString = notification.userInfo![StorageServiceEvents.streamType] as! String
        let streamType = StreamType(rawValue: streamTypeString)
        if streamType != stream!.streamType || viewModel!.isKindOfClass(GatewayViewModel) {
            return
        }
        
        // Remove loading screen and display stream content
        viewModel = GatewayViewModel(stream: stream!, collectionView: streamCollectionView, flowLayoutDelegate: self)
        viewModel!.updateCollectionView(true)
    }

    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeMake(CGRectGetWidth(collectionView.bounds), 290)
        } else {
            return CGSizeMake(CGRectGetWidth(collectionView.bounds), 8)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if viewModel!.isKindOfClass(GatewayInitialLoadingViewModel) {
            return CGSizeZero
        } else {
            return CGSizeMake(CGRectGetWidth(collectionView.bounds), 26)
        }
    }
}
