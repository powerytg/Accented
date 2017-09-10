//
//  AboutViewController.swift
//  Accented
//
//  Created by Tiangong You on 9/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var aboutHeaderLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var aboutButton: PushButton!
    @IBOutlet weak var feedbackHeaderLabel: UILabel!
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var feedbackButton: PushButton!

    private var backgroundView : DetailBackgroundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView = DetailBackgroundView(frame: self.view.bounds)
        self.view.insertSubview(backgroundView, at: 0)
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
        let to = "powerytg@gmail.com"
        let subject = "Accent app feedback"
        let urlString = "mailto:\(to)?subject=\(subject)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
