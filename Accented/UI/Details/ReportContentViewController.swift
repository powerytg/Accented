//
//  ReportContentViewController.swift
//  Accented
//
//  Created by You, Tiangong on 9/13/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class ReportContentViewController: UIViewController, Composer {

    @IBOutlet weak var composerView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var composerHeightConstraint: NSLayoutConstraint!
    
    private let transitionController = ComposerPresentationController()
    private let cornerRadius : CGFloat = 20
    private let titleBarMaskLayer = CAShapeLayer()
    private let titleBarRectCorner = UIRectCorner([.topLeft, .topRight])
    private let textEditBackgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    private let textEditCornderRadius : CGFloat = 4
    private var photo : PhotoModel

    init(_ photo : PhotoModel) {
        self.photo = photo
        super.init(nibName: "ReportContentViewController", bundle: nil
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        composerView.alpha = 0
        composerView.layer.cornerRadius = cornerRadius
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateTitlebarCorners()
    }
    
    private func updateTitlebarCorners() {
        let path = UIBezierPath(roundedRect: titleView.bounds,
                                byRoundingCorners: titleBarRectCorner,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        titleBarMaskLayer.path = path.cgPath
        titleView.layer.mask = titleBarMaskLayer
    }
    
    @IBAction func backButtonDidTap(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
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
        self.view.transform = CGAffineTransform(translationX: 0, y: -composerHeightConstraint.constant)
        self.view.alpha = 0
    }
    
    func exitAnimationDidFinish() {
        // Ignore
    }
}
