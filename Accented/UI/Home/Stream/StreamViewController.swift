//
//  StreamViewController.swift
//  Accented
//
//  Created by Tiangong You on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamViewController : InfiniteLoadingViewController<PhotoModel> {
    // Data model
    var stream : StreamModel!

    // View model
    var streamViewModel : StreamViewModel? {
        return viewModel as? StreamViewModel
    }
    
    init(_ stream : StreamModel) {
        self.stream = stream
        super.init()
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(streamDidUpdate(_:)), name: StorageServiceEvents.streamDidUpdate, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load stream if necessary
        if let vm = streamViewModel {
            vm.collection = stream
            vm.loadIfNecessary()
        }
    }
    
    func switchStream(_ newStream : StreamModel) {
        self.stream = newStream

        // Load stream if necessary
        if let vm = streamViewModel {
            vm.collection = newStream
            vm.loadIfNecessary()
        }
    }
    
    func streamDidUpdate(_ notification : Notification) -> Void {
        let streamId = notification.userInfo![StorageServiceEvents.streamId] as! String
        let page = notification.userInfo![StorageServiceEvents.page] as! Int
        guard streamId == stream.streamId else { return }
        
        // Get a new copy of the stream
        stream = StorageService.sharedInstance.getStream(stream.streamType)
        
        // Notify view model to update
        if let vm = streamViewModel {
            vm.collecitonDidUpdate(collection: stream, page: page)
        }
    }
}
