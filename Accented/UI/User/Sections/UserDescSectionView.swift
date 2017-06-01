//
//  UserDescSectionView.swift
//  Accented
//
//  Description section view
//
//  Created by Tiangong You on 5/29/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class UserDescSectionView: UserSectionViewBase {
    fileprivate let linkColor = ThemeManager.sharedInstance.currentTheme.linkColor
    fileprivate let linkHighlightColor = ThemeManager.sharedInstance.currentTheme.linkHighlightColor
    fileprivate var descLabel = TTTAttributedLabel(frame: CGRect.zero)
    fileprivate var formattedDescription : NSAttributedString?
    fileprivate var descSize : CGSize?
    fileprivate let descFont = UIFont(name: "HelveticaNeue-Light", size: 18)
    fileprivate let descColor = UIColor(red: 152 / 255.0, green: 152 / 255.0, blue: 152 / 255.0, alpha: 1)

    override func createContentView() {
        super.createContentView()
        
        descLabel.font = descFont
        descLabel.textColor = descColor
        descLabel.numberOfLines = 0
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.linkAttributes = [NSForegroundColorAttributeName : linkColor, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleNone.rawValue]
        descLabel.activeLinkAttributes = [NSForegroundColorAttributeName : linkHighlightColor, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleNone.rawValue]
        contentView.addSubview(descLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let desc = formattedDescription {
            descLabel.frame = CGRect(x: contentLeftPadding, y: contentTopPadding, width: descSize!.width, height: descSize!.height)
            descLabel.setText(desc)
        }
    }
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        guard let desc = user.about else { return 0 }
        
        let descStringWithStyles = NSString(format:"<span style=\"color: #989898; font-family: \(descFont!.fontName); font-size: \(descFont!.pointSize)\">%@</span>" as NSString, desc) as String
        guard let data = descStringWithStyles.data(using: String.Encoding.utf8) else { return 0 }
        
        let options : [String : Any] = [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                        NSCharacterEncodingDocumentAttribute:String.Encoding.utf8.rawValue]
        
        var formattedDesc : NSAttributedString?
        do {
            formattedDesc = try NSAttributedString(data: data, options: options, documentAttributes: nil)
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
            formattedDesc = nil
        }
        
        formattedDescription = formattedDesc
        if formattedDescription == nil {
            // If there's no description text available, then hide the section all together
            return 0
        } else {
            // Measure the description text
            let availableSize = CGSize(width: maxWidth - contentLeftPadding - contentRightPadding, height: CGFloat.greatestFiniteMagnitude)
            descSize = formattedDesc!.boundingRect(with: availableSize, options: .usesLineFragmentOrigin, context: nil).size
            return descSize!.height + contentTopPadding + contentBottomPadding
        }
    }
    
    override func adjustTextClarity() {
        descLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        descLabel.layer.shadowOpacity = 1
        descLabel.layer.shadowRadius = 1
        descLabel.layer.shadowOpacity = 0.6
    }
}
