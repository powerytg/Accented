//
//  AboutViewController.swift
//  Accented
//
//  Created by Tiangong You on 9/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var aboutHeaderLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var aboutButton: PushButton!
    @IBOutlet weak var feedbackHeaderLabel: UILabel!
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var feedbackButton: PushButton!

    private var backgroundView : DetailBackgroundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if ThemeManager.sharedInstance.currentTheme is DarkTheme {
            backButton.setImage(UIImage(named: "DetailBackButton"), for: .normal)
        } else {
            backButton.setImage(UIImage(named: "LightDetailBackButton"), for: .normal)
        }

        backgroundView = DetailBackgroundView(frame: self.view.bounds)
        self.view.insertSubview(backgroundView, at: 0)
        
        aboutTextView.textColor = ThemeManager.sharedInstance.currentTheme.aboutTextColor
        
        feedbackTextView.textColor = ThemeManager.sharedInstance.currentTheme.aboutTextColor

        aboutHeaderLabel.textColor = ThemeManager.sharedInstance.currentTheme.titleTextColor
        
        feedbackHeaderLabel.textColor = ThemeManager.sharedInstance.currentTheme.titleTextColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        backgroundView.frame = view.bounds
    }
    
    @IBAction func aboutButtonDidTap(_ sender: Any) {
        if let url = URL(string: "http://powerytg.org") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func feedbackButtonDidTap(_ sender: Any) {
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["powerytg@gmail.com"])
        composer.setSubject("Accented app feedback")
        present(composer, animated: true, completion: nil)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
