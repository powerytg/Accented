//
//  ReportContentViewController.swift
//  Accented
//
//  Created by You, Tiangong on 9/13/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import RMessage

class ReportContentViewController: UIViewController, MenuDelegate {

    @IBOutlet weak var composerView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var composerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var reasonButton: PushButton!
    @IBOutlet weak var detailReasonView: KMPlaceholderTextView!
    
    private let cornerRadius : CGFloat = 20
    private let titleBarMaskLayer = CAShapeLayer()
    private let titleBarRectCorner = UIRectCorner([.topLeft, .topRight])
    private let textEditBackgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    private let textEditCornderRadius : CGFloat = 4
    private var photo : PhotoModel
    private var reason : ReportReason?

    private let reasonMenu = [MenuItem(action: .ReportOffensive, text: "Offensive"),
                              MenuItem(action: .ReportSpam, text: "Spam"),
                              MenuItem(action: .ReportOfftopic, text: "Offtopic"),
                              MenuItem(action: .ReportCopyright, text: "Copyright"),
                              MenuItem(action: .ReportWrongContent, text: "Wrong content"),
                              MenuItem(action: .ReportAdultContent, text: "Adult content"),
                              MenuItem(action: .ReportOtherReason, text: "Other reasons")]
    
    init(_ photo : PhotoModel) {
        self.photo = photo
        super.init(nibName: "ReportContentViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        composerView.layer.cornerRadius = cornerRadius
        
        reportButton.isEnabled = false
        reportButton.alpha = 0.5
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
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reasonButtonDidTap(_ sender: Any) {
        let reasonMenu = MenuViewController(self.reasonMenu)
        reasonMenu.title = "SELECT A REASON"
        reasonMenu.delegate = self
        reasonMenu.show()
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reportButtonDidTap(_ sender: Any) {
        guard reason != nil else { return }
        
        let detailReason = detailReasonView.text.lengthOfBytes(using: .utf8) == 0 ? nil : detailReasonView.text
        
        view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 0.5
        }
        
        RMessage.showNotification(withTitle: "Reporting photo...", subtitle: "", type: .success, customTypeName: nil, duration: TimeInterval(RMessageDuration.endless.rawValue), callback: nil)
        APIService.sharedInstance.reportPhoto(photoId: photo.photoId, reason: reason!, details: detailReason, success: { [weak self] in
            RMessage.dismissActiveNotification()
            self?.reportDidSucceed()
        }) { [weak self] (errorMessage) in
            RMessage.dismissActiveNotification()
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    private func reportDidSucceed() {
        RMessage.showNotification(withTitle: "Report completed", type: .success, customTypeName: nil, callback: nil)
        
        // Wait for a few seconds and then go back
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    // MARK: - MenuDelegate
    
    func didSelectMenuItem(_ menuItem: MenuItem) {
        switch menuItem.action {
        case .ReportOtherReason:
            reason = .Other
        case .ReportAdultContent:
            reason = .AdultContent
        case .ReportWrongContent:
            reason = .WrongContent
        case .ReportCopyright:
            reason = .Copyright
        case .ReportOfftopic:
            reason = .Offtopic
        case .ReportOffensive:
            reason = .Offensive
        case .ReportSpam:
            reason = .Spam
        default:
            break
        }
        
        reasonButton.setTitle(menuItem.text, for: .normal)
        reportButton.isEnabled = true
        reportButton.alpha = 1
    }
}
