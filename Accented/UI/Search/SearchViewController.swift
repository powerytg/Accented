//
//  SearchViewController.swift
//  Accented
//
//  Created by Tiangong You on 8/27/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class SearchViewController: UIViewController, Composer, UITextViewDelegate {
    
    @IBOutlet weak var composerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var composerHeightConstraint: NSLayoutConstraint!
    
    private let cornerRadius : CGFloat = 20
    private let statusViewPaddingTop : CGFloat = 20
    private let titleBarMaskLayer = CAShapeLayer()
    private let titleBarRectCorner = UIRectCorner([.topLeft, .topRight])
    private let transitionController = ComposerPresentationController()
    private var currentStatusView : UIView?
    
    override var nibName: String? {
        return "SearchViewController"
    }
    
    init() {
        super.init(nibName: "SearchViewController", bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = transitionController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        composerView.backgroundColor = ThemeManager.sharedInstance.currentTheme.composerBackground
        textView.placeholderColor = ThemeManager.sharedInstance.currentTheme.composerPlaceholderTextColor
        textView.textColor = ThemeManager.sharedInstance.currentTheme.composerTextColor
        
        composerView.alpha = 0
        composerView.layer.cornerRadius = cornerRadius
        textView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
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
    
    @IBAction func searchButtonDidTap(_ sender: Any) {
        dismiss(animated: false) { 
            NavigationService.sharedInstance.navigateToSearchResultPage(keyword: self.textView.text)
        }
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
        searchButton.isEnabled = (textView.text.lengthOfBytes(using: String.Encoding.utf8) != 0)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if textView.text.lengthOfBytes(using: String.Encoding.utf8) != 0 {
                textView.resignFirstResponder()
                dismiss(animated: false) {
                    NavigationService.sharedInstance.navigateToSearchResultPage(keyword: self.textView.text)
                }
            }
            
            return false
        }
        return true
    }
}
