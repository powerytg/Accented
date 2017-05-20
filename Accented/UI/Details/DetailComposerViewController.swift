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

class DetailComposerViewController: UIViewController, EntranceAnimation, ExitAnimation, UITextViewDelegate {

    @IBOutlet weak var composerView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var composerHeightConstraint: NSLayoutConstraint!
    
    fileprivate var photo : PhotoModel
    fileprivate let cornerRadius : CGFloat = 20
    fileprivate let statusViewPaddingTop : CGFloat = 20
    fileprivate let titleBarMaskLayer = CAShapeLayer()
    fileprivate let titleBarRectCorner = UIRectCorner([.topLeft, .topRight])
    fileprivate let transitionController = DetailComposerPresentationController()
    fileprivate var currentStatusView : UIView?
    
    override var nibName: String? {
        return "DetailComposerViewController"
    }
    
    init(photo : PhotoModel) {
        self.photo = photo
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
        textView.isEditable = false
        sendButton.isEnabled = false
        transitionToStatusView(progressView)
        
        APIService.sharedInstance.addComment(self.photo.photoId, content: textView.text!, success: { [weak self] in
            self?.commentDidPost()
        }) { [weak self] (error) in
            self?.commentFailedPost()
        }
    }
    
    fileprivate func commentDidPost() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.transitionToStatusView(self.successView)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }

    fileprivate func commentFailedPost() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.transitionToStatusView(self.errorView)
            self.textView.isEditable = true
            self.sendButton.isEnabled = (self.textView.text.lengthOfBytes(using: String.Encoding.utf8) != 0)
        }
    }

    fileprivate func showStatusView(_ view : UIView) {
        var f = view.frame
        f.origin.x = composerView.frame.origin.x + 8
        f.origin.y = composerView.frame.origin.y + composerView.frame.size.height + statusViewPaddingTop
        view.frame = f
        
        if view == progressView {
            progressIndicator.startAnimating()
        } else {
            progressIndicator.stopAnimating()
        }
        
        currentStatusView = view
        UIView.animate(withDuration: 0.2) { 
            view.alpha = 1
        }
    }
    
    fileprivate func transitionToStatusView(_ view : UIView) {
        guard let previousStatusView = currentStatusView else {
            showStatusView(view)
            return
        }
        
        let tx : CGFloat = 30
        var f = view.frame
        f.origin.x = composerView.frame.origin.x + 8
        f.origin.y = composerView.frame.origin.y + composerView.frame.size.height + statusViewPaddingTop
        view.frame = f
        view.alpha = 0
        view.transform = CGAffineTransform(translationX: tx, y: 0)
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                previousStatusView.transform = CGAffineTransform(translationX: -tx, y: 0)
                previousStatusView.alpha = 0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 1, animations: {
                view.transform = CGAffineTransform.identity
                view.alpha = 1
            })
        }) { [weak self] (finished) in
            previousStatusView.transform = CGAffineTransform.identity
            self?.currentStatusView = view
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
        sendButton.isEnabled = (textView.text.lengthOfBytes(using: String.Encoding.utf8) != 0)
    }
    
}
