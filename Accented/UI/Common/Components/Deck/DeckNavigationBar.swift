//
//  DeckNavigationBar.swift
//  Accented
//
//  Deck navigaton view
//
//  Created by Tiangong You on 5/21/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

protocol DeckNavigationBarDelegate : NSObjectProtocol {
    func navButtonSelectedIndexDidChange(fromIndex : Int, toIndex : Int)
}

class DeckNavigationBar: UIView {

    fileprivate var indicator = UIView()
    fileprivate var navButtons = [UIButton]()
    var selectedIndex = 0 {
        didSet {
            UIView.animate(withDuration: 0.2, animations: { 
                self.layoutIndicatorView()
            }) { (finished) in
                self.setNeedsLayout()
            }
        }
    }
    
    fileprivate let indicatorHeight : CGFloat = 4
    fileprivate let indicatorPaddingLeft : CGFloat = 5
    fileprivate let indicatorPaddingRight : CGFloat = 10
    fileprivate let gap : CGFloat = 25
    fileprivate let unselectedColor = UIColor(red: 81 / 255.0, green: 81 / 255.0, blue: 81 / 255.0, alpha: 1)
    fileprivate let selectedColor = UIColor.white
    
    weak var delegate : DeckNavigationBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    fileprivate func initialize() {
        addSubview(indicator)
        indicator.backgroundColor = ThemeManager.sharedInstance.currentTheme.navButtonSelectedColor        
    }
    
    // Reference to the data source
    weak var dataSource : DeckViewControllerDataSource? {
        didSet {
            navButtons.removeAll()
            createNavButtons()
            setNeedsLayout()
        }
    }

    fileprivate func createNavButtons() {
        if let ds = dataSource {
            let buttonCount = ds.numberOfCards()
            if buttonCount == 0 {
                return
            }
            
            for index in 0...(buttonCount - 1) {
                let card = ds.cardForItemIndex(index)
                let button = UIButton()
                button.setTitleColor(unselectedColor, for: .normal)
                button.setTitle(card.title, for: .normal)
                button.addTarget(self, action: #selector(navButtonDidTap(_ :)), for: .touchUpInside)
                navButtons.append(button)
                addSubview(button)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard navButtons.count > 0 else { return }
        
        var nextX : CGFloat = indicatorPaddingLeft
        for (index, button) in navButtons.enumerated() {
            let selected = (index == selectedIndex)
            button.titleLabel?.font = selected ?
                ThemeManager.sharedInstance.currentTheme.selectedCardNavFont
                : ThemeManager.sharedInstance.currentTheme.normalCardNavFont
            
            let titleColor = selected ? selectedColor : unselectedColor
            button.setTitleColor(titleColor, for: .normal)
            button.sizeToFit()
            
            var f = button.frame
            f.origin.x = nextX
            f.origin.y = bounds.size.height / 2 - f.size.height / 2
            button.frame = f
            nextX += f.size.width + gap
        }
        
        layoutIndicatorView()
    }
    
    fileprivate func layoutIndicatorView() {
        let selectedButtonFrame = navButtons[selectedIndex].frame
        var indicatorFrame = indicator.frame
        indicatorFrame.size.height = indicatorHeight
        indicatorFrame.origin.x = selectedButtonFrame.origin.x - indicatorPaddingLeft
        indicatorFrame.origin.y = bounds.height - indicatorFrame.size.height
        indicatorFrame.size.width = selectedButtonFrame.size.width + indicatorPaddingLeft + indicatorPaddingRight
        indicator.frame = indicatorFrame
    }
    
    @objc fileprivate func navButtonDidTap(_ button : UIButton) {
        let toIndex = navButtons.index(of: button)
        if toIndex == selectedIndex {
            return
        }
        
        delegate?.navButtonSelectedIndexDidChange(fromIndex: selectedIndex, toIndex: toIndex!)
        selectedIndex = toIndex!
    }
}
