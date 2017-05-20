//
//  DetailComposerViewController.swift
//  Accented
//
//  Comment and reply composer
//
//  Created by Tiangong You on 5/20/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class DetailComposerViewController: UIViewController, EntranceAnimation, ExitAnimation {

    @IBOutlet weak var composerView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    
    @IBOutlet weak var composerHeightConstraint: NSLayoutConstraint!
    
    fileprivate let cornerRadius : CGFloat = 20
    fileprivate let titleBarMaskLayer = CAShapeLayer()
    fileprivate let titleBarRectCorner = UIRectCorner([.topLeft, .topRight])
    fileprivate let transitionController = DetailComposerPresentationController()
    
    override var nibName: String? {
        return "DetailComposerViewController"
    }
    
    init() {
        super.init(nibName: "DetailComposerViewController", bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = transitionController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        composerView.alpha = 0
        composerView.layer.cornerRadius = cornerRadius
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateTitlebarCorners()
    }

    fileprivate func updateTitlebarCorners() {
        let path = UIBezierPath(roundedRect: titleView.bounds,
                                byRoundingCorners: titleBarRectCorner,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        titleBarMaskLayer.path = path.cgPath
        titleView.layer.mask = titleBarMaskLayer
    }

    @IBAction func backButtonDidTap(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonDidTap(_ sender: Any) {
        
    }
    
    // MARK: - EntranceAnimation
    
    func entranceAnimationWillBegin() {
        composerView.transform = CGAffineTransform(translationX: 0, y: -composerHeightConstraint.constant)
    }
    
    func performEntranceAnimation() {
        composerView.transform = CGAffineTransform.identity
        composerView.alpha = 1
    }
    
    func entranceAnimationDidFinish() {
        // Ignore
    }
    
    // MARK: - ExitAnimation
    
    func exitAnimationWillBegin() {
        composerView.resignFirstResponder()
    }
    
    func performExitAnimation() {
        composerView.transform = CGAffineTransform(translationX: 0, y: -composerHeightConstraint.constant)
        composerView.alpha = 0
    }
    
    func exitAnimationDidFinish() {
        // Ignore
    }
}
