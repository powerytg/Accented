//
//  TermsViewController.swift
//  Accented
//
//  Created by Tiangong You on 9/13/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(cancelButtonDidTap(_:)))

        let url = URL(string: "http://powerytg.org/terms/accented.html")
        let request = URLRequest(url: url!)
        webview.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func cancelButtonDidTap(_ sender: AnyObject!) -> Void {
        self.dismiss(animated: true, completion: nil)
    }

}
