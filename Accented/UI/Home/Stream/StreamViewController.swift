//
//  StreamViewController.swift
//  Accented
//
//  Created by Tiangong You on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamViewController : InfiniteLoadingViewController {
    // Data model
    var stream : StreamModel!

    // View model
    var streamViewModel : StreamViewModel? {
        return viewModel as? StreamViewModel
    }
    
    init(_ stream : StreamModel) {
        super.init()
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(streamDidUpdate(_:)), name: StorageServiceEvents.streamDidUpdate, object: nil)

        // Make a protective copy of the stream object
        StorageService.sharedInstance.synchronized(stream) { 
            self.stream = stream.copy() as! StreamModel
        }
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
            vm.stream = stream
            vm.loadStreamIfNecessary()
        }
    }
    
    func switchStream(_ newStream : StreamModel) {
        // Make a protective copy of the stream object
        StorageService.sharedInstance.synchronized(newStream) {
            self.stream = newStream.copy() as! StreamModel
        }

        // Load stream if necessary
        if let vm = streamViewModel {
            vm.stream = stream
            vm.loadStreamIfNecessary()
        }
    }
    
    func streamDidUpdate(_ notification : Notification) -> Void {
        let streamTypeString = (notification as NSNotification).userInfo![StorageServiceEvents.streamType] as! String
        let streamType = StreamType(rawValue: streamTypeString)
        let page = (notification as NSNotification).userInfo![StorageServiceEvents.page] as! Int
        if streamType != stream.streamType {
            return
        }
        
        // Make a protective copy of the stream object
        let streamModel = StorageService.sharedInstance.getStream(streamType!)
        StorageService.sharedInstance.synchronized(streamModel) {
            self.stream = streamModel.copy() as! StreamModel
        }

        if let vm = streamViewModel {
            vm.streamDidUpdate(stream: stream, page: page)
        }
    }
}
