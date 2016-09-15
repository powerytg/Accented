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
    private var maxWidth : CGFloat
    private var cacheController : DetailCacheController
    
    private var backgroundView = UIImageView()
    private var authorLabel = UILabel()
    private var contentLabel = UILabel()
    private var avatarView = UIImageView()
    
    private var authorFont = UIFont(name: "AvenirNextCondensed-Bold", size: 13)!
    private var contentFont = UIFont(name: "HelveticaNeue-LightItalic", size: 16)!
    private var paddingLeft : CGFloat = 24
    private var paddingRight : CGFloat = 20
    private var paddingTop : CGFloat = 6
    private var paddingBottom : CGFloat = 10
    private var vPadding : CGFloat = 5
    private var avatarSize : CGFloat = 40
    private var backgroundMarginLeft : CGFloat = 5
    
    init(_ style : CommentRendererStyle, maxWidth : CGFloat, cacheController : DetailCacheController) {
        self.style = style
        self.maxWidth = maxWidth
        self.cacheController = cacheController
        super.init(frame : CGRect.zero)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func initialize() {

        // Specify background
        addSubview(backgroundView)
        switch style {
        case .Light:
            backgroundView.image = UIImage(named: "LightBubble")
        case .Dark:
            backgroundView.image = UIImage(named: "DarkBubble")
        }

        // Avatar
        addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 8
        
        // Author
        addSubview(authorLabel)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.preferredMaxLayoutWidth = maxWidth - paddingLeft - paddingRight
        authorLabel.textColor = UIColor.white
        authorLabel.lineBreakMode = .byWordWrapping
        authorLabel.numberOfLines = 0
        authorLabel.font = authorFont

        // body label
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.preferredMaxLayoutWidth = maxWidth - paddingLeft - paddingRight
        contentLabel.textColor = UIColor(red: 170 / 255.0, green: 170 / 255.0, blue: 170 / 255.0, alpha: 1)
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.font = contentFont
    
        // Constraints
        avatarView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        avatarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        avatarView.widthAnchor.constraint(equalToConstant: avatarSize).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: avatarSize).isActive = true
        
        authorLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: paddingLeft).isActive = true
        authorLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: paddingTop).isActive = true
        
        contentLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor).isActive = true
        contentLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: vPadding).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard comment != nil else { return }
        
        if let avatarUrl = DetailUserUtils.preferredAvatarUrl(comment!.user) {
            avatarView.sd_setImage(with: avatarUrl)
        }

        authorLabel.text = TextUtils.preferredAuthorName(comment!.user).uppercased()
        contentLabel.text = comment!.body
        
        var f = backgroundView.frame
        f.origin.x = avatarSize + backgroundMarginLeft
        f.size.width = self.bounds.size.width - f.origin.x
        f.size.height = self.bounds.size.height
        backgroundView.frame = f
    }
    
    fileprivate func commentModelDidChange() {
        setNeedsLayout()
    }
    
    func estimatedSize(_ comment : CommentModel, width : CGFloat) -> CGSize {
        let cachedSize = cacheController.getCommentMeasurement(comment.commentId)
        if cachedSize != nil {
            return cachedSize!
        }
        
        let availableWidth = width - paddingLeft - paddingRight - avatarSize
        let author = TextUtils.preferredAuthorName(comment.user)
        let paramStyle = NSMutableParagraphStyle()
        paramStyle.lineBreakMode = .byCharWrapping
        let authorAttrs = [NSFontAttributeName: authorFont, NSParagraphStyleAttributeName : paramStyle] as [String : Any]
        let bodyAttrs = [NSFontAttributeName: contentFont, NSParagraphStyleAttributeName : paramStyle] as [String : Any]
        
        // Measure author
        let authorString = NSAttributedString(string: author, attributes: authorAttrs)
        let authorSize = authorString.boundingRect(with: CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude),
                                                                    options: .usesLineFragmentOrigin,
                                                                    context: nil).size
        
        // Measure body
        let bodyString = NSAttributedString(string: comment.body, attributes: bodyAttrs)
        let bodySize = bodyString.boundingRect(with: CGSize(width: availableWidth, height: CGFloat.greatestFiniteMagnitude),
                                                                        options: .usesLineFragmentOrigin,
                                                                        context: nil).size
        
        let measuredWidth = max(authorSize.width, bodySize.width) + paddingLeft + paddingRight + avatarSize + backgroundMarginLeft
        let measuredHeight = authorSize.height + bodySize.height + vPadding + paddingTop + paddingBottom
        let measuredSize = CGSize(width: measuredWidth, height: measuredHeight)
        cacheController.setCommentMeasurement(measuredSize, commentId: comment.commentId)
        return measuredSize
    }
}
