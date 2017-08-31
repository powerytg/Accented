//
//  ImageLoaderViewController.swift
//  Accented
//
//  Created by Tiangong You on 8/28/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class ImageLoaderViewController: UIViewController, Composer, UITextViewDelegate {

    @IBOutlet weak var composerView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var privacyView: UISegmentedControl!
    @IBOutlet weak var categoryButton: PushButton!
    @IBOutlet weak var nameEdit: UITextField!
    @IBOutlet weak var descEdit: KMPlaceholderTextView!
    @IBOutlet weak var composerHeightConstraint: NSLayoutConstraint!

    private let transitionController = ComposerPresentationController()
    private let cornerRadius : CGFloat = 20
    private let titleBarMaskLayer = CAShapeLayer()
    private let titleBarRectCorner = UIRectCorner([.topLeft, .topRight])
    private let textEditBackgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    private let textEditCornderRadius : CGFloat = 4

    init() {
        super.init(nibName: "ImageLoaderViewController", bundle: nil)
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
        
        nameEdit.backgroundColor = textEditBackgroundColor
        descEdit.backgroundColor = textEditBackgroundColor
        
        nameEdit.layer.cornerRadius = textEditCornderRadius
        descEdit.layer.cornerRadius = textEditCornderRadius

        descEdit.delegate = self
        nameEdit.addTarget(self, action: #selector(nameEditDidChange(_:)), for: .editingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameEdit.becomeFirstResponder()
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
    
    @IBAction func backButtonDidTap(_ sender: Any) {
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
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        toggleUploadButtonState()
    }

    @objc private func nameEditDidChange(_ sender : UITextField) {
        toggleUploadButtonState()
    }
    
    private func toggleUploadButtonState() {
        if (nameEdit.text?.lengthOfBytes(using: .utf8) != 0 && descEdit.text?.lengthOfBytes(using: .utf8) != 0) {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
    }
    
}
