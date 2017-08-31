//
//  SheetMenuViewController.swift
//  Accented
//
//  Created by You, Tiangong on 8/31/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

protocol SheetMenuViewControllerDelegate : NSObjectProtocol {
    func sheetMenuSelectedOptionDidChange(menuSheet : SheetMenuViewController, selectedIndex : Int)
}

class SheetMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var model : BottomSheetModel
    private let cellIdentifier = "cell"
    weak var delegate : SheetMenuViewControllerDelegate?
    
    var initialSelectedIndex : Int {
        return 0
    }
    
    init(model : BottomSheetModel) {
        self.model = model
        super.init(nibName: "SearchResultSortingBottomSheetViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "SearchResultSortingOptionRenderer", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Select the row that has the current option
        let path = IndexPath(row: initialSelectedIndex, section: 0)
        tableView.selectRow(at: path, animated: false, scrollPosition: .top)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortingModel.supportedPhotoSearchSortingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = sortingModel.supportedPhotoSearchSortingOptions[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchResultSortingOptionRenderer
        if cell == nil {
            cell = SearchResultSortingOptionRenderer(option: option, identifier: cellIdentifier)
        }
        
        cell!.isSelected = (option == sortingModel.selectedOption)
        cell!.option = option
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0, y: 80)
        cell.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.03 * Double(indexPath.row), options: .curveEaseOut, animations: {
            cell.transform = CGAffineTransform.identity
            cell.alpha = 1
            }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = sortingModel.supportedPhotoSearchSortingOptions[indexPath.row]
        delegate?.sheetMenuSelectedOptionDidChange(menuSheet: self, selectedIndex: indexPath.row)
    }


}
