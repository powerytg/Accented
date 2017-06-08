//
//  CommentRenderer.swift
//  Accented
//
//  Created by Tiangong You on 8/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

enum CommentRendererStyle {
    case Light
    case Dark
}

class CommentRenderer: UIView {

    // Data model
    var comment : CommentModel? {
        didSet {
            commentModelDidChange()
        }
    }
    
    var style : CommentRendererStyle
    
    private var backgroundView = UIImageView()
    private var authorLabel = UILabel()
    private var contentLabel = UILabel()
    private var avatarView = UIImageView()
    
    private static let authorFont = UIFont(name: "AvenirNextCondensed-Bold", size: 13)!
    private static let contentFont = UIFont(name: "HelveticaNeue-LightItalic", size: 16)!
    private static let paddingLeft : CGFloat = 24
    private static let paddingRight : CGFloat = 20
    private static let paddingTop : CGFloat = 6
    private static let paddingBottom : CGFloat = 8
    private static let vPadding : CGFloat = 5
    private static let avatarSize : CGFloat = 40
    private static let backgroundMarginLeft : CGFloat = 5
    
    init(_ style : CommentRendererStyle) {
        self.style = style
        super.init(frame : CGRect.zero)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize() {
        // Specify background
        addSubview(backgroundView)
        
        // Avatar
        addSubview(avatarView)
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 8
        
        // Author
        addSubview(authorLabel)
        authorLabel.textColor = UIColor.white
        authorLabel.lineBreakMode = .byWordWrapping
        authorLabel.numberOfLines = 0
        authorLabel.font = CommentRenderer.authorFont

        // body label
        addSubview(contentLabel)
        contentLabel.textColor = UIColor(red: 170 / 255.0, green: 170 / 255.0, blue: 170 / 255.0, alpha: 1)
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.font = CommentRenderer.contentFont
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard comment != nil else { return }
        
        if let avatarUrl = DetailUserUtils.preferredAvatarUrl(comment!.user) {
            avatarView.sd_setImage(with: avatarUrl)
        }

        authorLabel.text = TextUtils.preferredAuthorName(comment!.user).uppercased()
        contentLabel.text = comment!.body
        
        switch style {
        case .Light:
            backgroundView.image = UIImage(named: "LightBubble")
        case .Dark:
            backgroundView.image = UIImage(named: "DarkBubble")
        }

        var f = backgroundView.frame
        f.origin.x = CommentRenderer.avatarSize + CommentRenderer.backgroundMarginLeft
        f.size.width = bounds.size.width - f.origin.x
        f.size.height = bounds.size.height
        backgroundView.frame = f
        
        f = avatarView.frame
        f.size.width = CommentRenderer.avatarSize
        f.size.height = CommentRenderer.avatarSize
        f.origin.y = bounds.size.height - f.size.height
        avatarView.frame = f
        let avatarRight = f.origin.x + f.size.width
        
        let maxWidth = CommentRenderer.maxAvailableTextWidth(bounds.size.width)
        f = authorLabel.frame
        f.size.width = maxWidth
        f.origin.x = avatarRight + CommentRenderer.paddingLeft
        f.origin.y = CommentRenderer.paddingTop
        authorLabel.frame = f
        authorLabel.sizeToFit()
        let authorBottom = authorLabel.frame.origin.y + authorLabel.frame.size.height
        
        f = contentLabel.frame
        f.size.width = maxWidth
        f.origin.x = avatarRight + CommentRenderer.paddingLeft
        f.origin.y = authorBottom + CommentRenderer.vPadding
        contentLabel.frame = f
        contentLabel.sizeToFit()
    }
    
    private func commentModelDidChange() {
        setNeedsLayout()
    }
    
    static func estimatedSize(_ comment : CommentModel, width : CGFloat) -> CGSize {
        let availableTextWidth = maxAvailableTextWidth(width)
        let author = TextUtils.preferredAuthorName(comment.user).uppercased()
        
        // Measure author
        let authorString = NSAttributedString(string: author, attributes: authorStringAttrs)
        let authorSize = authorString.boundingRect(with: CGSize(width: availableTextWidth, height: CGFloat.greatestFiniteMagnitude),
                                                                    options: .usesLineFragmentOrigin,
                                                                    context: nil).size
        
        // Measure body
        let bodyString = NSAttributedString(string: comment.body, attributes: contentStringAttrs)
        let bodySize = bodyString.boundingRect(with: CGSize(width: availableTextWidth, height: CGFloat.greatestFiniteMagnitude),
                                                                        options: .usesLineFragmentOrigin,
                                                                        context: nil).size
        
        let measuredWidth = max(authorSize.width, bodySize.width) + paddingLeft + paddingRight + avatarSize + backgroundMarginLeft
        let measuredHeight = max(avatarSize, authorSize.height + bodySize.height + vPadding + paddingTop + paddingBottom)
        let measuredSize = CGSize(width: measuredWidth, height: measuredHeight)
        
        return measuredSize
    }
    
    private static func maxAvailableTextWidth(_ maxWidth : CGFloat) -> CGFloat {
        return maxWidth - paddingLeft - paddingRight - avatarSize - backgroundMarginLeft
    }
    
    private static var paramStyle : NSParagraphStyle {
        let paramStyle = NSMutableParagraphStyle()
        paramStyle.lineBreakMode = .byWordWrapping
        return paramStyle
    }
    
    private static var authorStringAttrs : [String : Any] {
        return [NSFontAttributeName: authorFont, NSParagraphStyleAttributeName : paramStyle] as [String : Any]
    }

    private static var contentStringAttrs : [String : Any] {
        return [NSFontAttributeName: contentFont, NSParagraphStyleAttributeName : paramStyle] as [String : Any]
    }
}
