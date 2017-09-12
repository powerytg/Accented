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

class UserDescSectionView: UserSectionViewBase, TTTAttributedLabelDelegate {
    private let linkColor = ThemeManager.sharedInstance.currentTheme.linkColor
    private let linkHighlightColor = ThemeManager.sharedInstance.currentTheme.linkHighlightColor
    private var descLabel = TTTAttributedLabel(frame: CGRect.zero)
    private var formattedDescription : NSAttributedString?
    private var descSize : CGSize?

    override var title: String? {
        return "ABOUT"
    }
    
    override func createContentView() {
        super.createContentView()
        
        descLabel.delegate = self
        descLabel.font = ThemeManager.sharedInstance.currentTheme.descFont
        descLabel.textColor = ThemeManager.sharedInstance.currentTheme.userProfileDescTextColor
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
        
        let descFont = ThemeManager.sharedInstance.currentTheme.descFont
        let descColor = ThemeManager.sharedInstance.currentTheme.descTextColorHex
        let descStringWithStyles = NSString(format:"<span style=\"color: \(descColor); font-family: \(descFont.fontName); font-size: \(descFont.pointSize)\">%@</span>" as NSString, desc) as String
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
            return descSize!.height + contentTopPadding + contentBottomPadding + sectionTitleHeight
        }
    }
    
    override func adjustTextClarity() {
        descLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        descLabel.layer.shadowOpacity = 1
        descLabel.layer.shadowRadius = 1
        descLabel.layer.shadowOpacity = 0.6
    }
    
    // MARK: - TTTAttributedLabelDelegate
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
