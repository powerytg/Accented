//
//  SearchResultFilterViewController.swift
//  Accented
//
//  Created by Tiangong You on 5/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

protocol SearchResultFilterViewControllerDelegate : NSObjectProtocol {
    func sortingButtonDidTap()
}

class SearchResultFilterViewController: UIViewController {

    @IBOutlet weak var sortButton: PushButton!
    private var sortingModel : PhotoSearchFilterModel
    
    weak var delegate : SearchResultFilterViewControllerDelegate?
    
    init(sortingModel : PhotoSearchFilterModel) {
        self.sortingModel = sortingModel
        super.init(nibName: "SearchResultFilterViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        sortButton.setTitle(TextUtils.sortOptionDisplayName(self.sortingModel.selectedOption), for: .normal)
    }
    
    @IBAction func sortingButtonDidTap(_ sender: Any) {
        delegate?.sortingButtonDidTap()
    }
}
