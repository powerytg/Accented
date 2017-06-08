//
//  StreamSelectorView.swift
//  Accented
//
//  Created by Tiangong You on 5/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DefaultStreamSelectorView: UIView {

    var topLine = CALayer()
    var bottomLine = CALayer()
    
    private let hGap : CGFloat = 20
    private var contentWidth : CGFloat = 0
    
    var compressionRateio : CGFloat = 0
    
    let displayStreamTypes : [StreamType] = [StreamType.Popular, StreamType.FreshToday, StreamType.Upcoming, StreamType.Editors]
    private var currentTab : UIButton?
    
    private var unselectedColor : UIColor {
        return ThemeManager.sharedInstance.currentTheme.navButtonNormalColor
    }
    
    private var selectedColor : UIColor {
        return ThemeManager.sharedInstance.currentTheme.navButtonSelectedColor
    }

    private var lineColor : UIColor {
        return ThemeManager.sharedInstance.currentTheme.navBarBorderColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        self.layer.addSublayer(topLine)
        self.layer.addSublayer(bottomLine)
        
        createTabs()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = self.bounds.width
        let h = self.bounds.height
        
        topLine.frame = CGRect(x: 0, y: 0, width: w, height: 1)
        bottomLine.frame = CGRect(x: 0, y: h - 1, width: w, height: 1)
        topLine.backgroundColor = lineColor.cgColor
        bottomLine.backgroundColor = lineColor.cgColor

        // Distrubute tabs
        var currentX = w / 2 - contentWidth / 2
        for tabView in self.subviews {
            var f = tabView.frame
            f.origin.x = currentX
            f.origin.y = h / 2 - f.height / 2
            tabView.frame = f
            tabView.setNeedsLayout()
            
            if tabView == currentTab {
                setToSelectedState(tabView as! UIButton, animated: false)
            } else {
                setToUnselectedState(tabView as! UIButton, animated: false)
            }
            
            currentX += f.width + hGap
        }
        
        // Update the top line based on compression ratio
        topLine.opacity = 1 - Float(compressionRateio)
    }
    
    private func createTabs() {
        for streamType in displayStreamTypes {
            let button = UIButton()
            button.setTitle(displayName(streamType), for: UIControlState())
            button.titleLabel!.font = UIFont(name: "Futura-CondensedMedium", size: 18)
            button.sizeToFit()
            self.addSubview(button)
            
            button.addTarget(self, action: #selector(tabDidTap(_:)), for: .touchUpInside)
            
            if streamType == StorageService.sharedInstance.currentStream.streamType {
                setToSelectedState(button, animated: false)
            } else {
                setToUnselectedState(button, animated: false)
            }
            
            contentWidth += button.bounds.width
        }
        
        contentWidth += hGap * CGFloat(displayStreamTypes.count - 1)
    }
    
    func tabDidTap(_ sender : UIButton) {
        if sender == currentTab {
            return
        }
        
        setToUnselectedState(currentTab!, animated: true)
        setToSelectedState(sender, animated: true, completed: { streamType in
            let userInfo = [StreamEvents.selectedStreamType : streamType.rawValue]
            NotificationCenter.default.post(name: StreamEvents.streamSelectionWillChange, object: nil, userInfo: userInfo)
        })
    }
    
    private func setToSelectedState(_ tab : UIButton, animated : Bool, completed : ((StreamType) -> Void)? = nil) {
        if animated {
            UIView.transition(with: tab, duration: 0.2, options: .transitionCrossDissolve, animations: { [weak self] in
                tab.setTitleColor(self?.selectedColor, for: UIControlState())
                }, completion: { (finished) in
                    if let completedAction = completed {
                        let selectedIndex = self.subviews.index(of: tab)
                        completedAction(self.displayStreamTypes[selectedIndex!])
                    }
            })
        } else {
            tab.setTitleColor(self.selectedColor, for: UIControlState())
        }
        
        currentTab = tab
    }

    private func setToUnselectedState(_ tab : UIButton, animated : Bool) {
        if animated {
            UIView.transition(with: tab, duration: 0.2, options: .transitionCrossDissolve, animations: { [weak self] in
                tab.setTitleColor(self?.unselectedColor, for: UIControlState())
                }, completion: { (completed) in
                    // Do nothing
            })
        } else {
            tab.setTitleColor(self.unselectedColor, for: UIControlState())
        }
    }

    private func displayName(_ streamType : StreamType) -> String {
        switch streamType {
        case .Popular:
            return "POPULAR"
        case .FreshToday:
            return "LATEST"
        case .Upcoming:
            return "UPCOMING"
        case .Editors:
            return "EDITORS' CHOICE"
        default:
            fatalError("StreamType not implemented")
        }
    }
}
