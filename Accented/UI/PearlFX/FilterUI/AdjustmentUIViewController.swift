//
//  AdjustmentUIViewController.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

protocol AdjustmentUIDelegate : NSObjectProtocol {
    func didRequestDismissCurrentAdjustmentUI()
}

class AdjustmentUIViewController: UIViewController {

    var filterManager : FilterManager
    var curtainView = UIView()
    weak var delegate : AdjustmentUIDelegate?
    
    init(_ filterManager : FilterManager) {
        self.filterManager = filterManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a curtain view
        view.insertSubview(curtainView, at: 0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnCurtain(_:)))
        curtainView.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        curtainView.frame = view.bounds
    }
    
    @objc private func didTapOnCurtain(_ tap : UITapGestureRecognizer) {
        delegate?.didRequestDismissCurrentAdjustmentUI()
    }
}
