//
//  DetailDescriptionSectionView.swift
//  Accented
//
//  Essential info section in detail page, consists the photo title, description and timestamp
//
//  Created by Tiangong You on 8/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import RMessage

class DetailDescriptionSectionView: DetailSectionViewBase {
    
    private var titleLabel = UILabel()
    private var dateLabel = UILabel()
    private var descLabel = TTTAttributedLabel(frame: CGRect.zero)
    private var voteButton : UIButton!
    
    private let titleFont = UIFont(name: "HelveticaNeue-Thin", size: 34)
    private let dateFont = UIFont(name: "HelveticaNeue", size: 14)
    private let descFont = ThemeManager.sharedInstance.currentTheme.descFont
    private let descColor = ThemeManager.sharedInstance.currentTheme.descTextColor
    private let linkColor = ThemeManager.sharedInstance.currentTheme.linkColor
    private let linkPressColor = ThemeManager.sharedInstance.currentTheme.linkHighlightColor
    
    private let titleTopPadding : CGFloat = 12
    private let titleRightPadding : CGFloat = 70
    private let dateRightPadding : CGFloat = 120
    private let descRightPadding : CGFloat = 30
    private let gap : CGFloat = 10

    private var formattedDescText : NSAttributedString?
    private var descSize : CGSize?
    
    override func initialize() {
        super.initialize()
        
        // Title label
        titleLabel.font = titleFont
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(titleLabel)

        // Date label
        dateLabel.font = dateFont
        dateLabel.textColor = UIColor.white
        contentView.addSubview(dateLabel)
        
        // Desc label
        descLabel.font = descFont
        descLabel.textColor = ThemeManager.sharedInstance.currentTheme.descTextColor
        descLabel.numberOfLines = 0
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.linkAttributes = [NSForegroundColorAttributeName : linkColor, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleNone.rawValue]
        descLabel.activeLinkAttributes = [NSForegroundColorAttributeName : linkPressColor, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleNone.rawValue]
        contentView.addSubview(descLabel)
        
        // Vote button
        // Note: Xcode crashes due to sigbart if seeing this:
        // let icon = photo.voted ? "DownVote" : "UpVote"
        var icon : String
        if photo.voted {
            icon = "DownVote"
        } else {
            icon = "UpVote"
        }
        
        voteButton = UIButton(type: .custom)
        voteButton.setImage(UIImage(named : icon), for: .normal)
        voteButton.sizeToFit()
        contentView.addSubview(voteButton)
        voteButton.addTarget(self, action: #selector(voteButtonDidTap(_:)), for: .touchUpInside)
        
        // Vote/unvote is only available for registered users
        // A user cannot like his/her own photo
        if let currentUser = StorageService.sharedInstance.currentUser {
            if photo.user.userId == currentUser.userId {
                voteButton.isHidden = true
            } else {
                voteButton.isHidden = false
            }
        } else {
            voteButton.isHidden = true
        }
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(photoVoteDidUpdate(_:)), name: StorageServiceEvents.photoVoteDidUpdate, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()        
        
        var nextY : CGFloat = contentTopPadding
        
        // Title
        titleLabel.text = photo.title
        var f = titleLabel.frame
        f.origin.x = contentLeftPadding
        f.origin.y = nextY
        f.size.width = width - contentLeftPadding - titleRightPadding
        titleLabel.frame = f
        titleLabel.text = photo.title
        titleLabel.sizeToFit()
        nextY += titleLabel.frame.size.height
        
        // Creation date
        if let dateString = displayDateString(photo) {
            nextY += gap
            dateLabel.isHidden = false
            f = dateLabel.frame
            f.origin.x = contentLeftPadding
            f.origin.y = nextY
            f.size.width = width - contentLeftPadding - dateRightPadding
            dateLabel.frame = f
            dateLabel.text = dateString
            dateLabel.sizeToFit()
            nextY += dateLabel.frame.size.height
        } else{
            dateLabel.isHidden = true
        }
        
        // Descriptions
        if formattedDescText != nil && descSize != nil {
            nextY += gap
            dateLabel.isHidden = false
            descLabel.setText(formattedDescText)
            f = descLabel.frame
            f.origin.x = contentLeftPadding
            f.origin.y = nextY
            f.size.width = descSize!.width
            f.size.height = descSize!.height
            descLabel.frame = f
        } else {
            descLabel.isHidden = true
        }
        
        // Vote button
        f = voteButton.frame
        f.origin.x = titleLabel.frame.maxX + 25
        f.origin.y = titleLabel.frame.midY - f.size.height / 2
        voteButton.frame = f
    }
    
    // MARK: - Measurments
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        var measuredHeight : CGFloat = contentTopPadding
        
        // Title
        let maxTitleWidth = width - contentLeftPadding - titleRightPadding
        let titleHeight = NSString(string : photo.title).boundingRect(with: CGSize(width: maxTitleWidth,
                                                                                   height: CGFloat.greatestFiniteMagnitude),
                                                                      options: .usesLineFragmentOrigin,
                                                                      attributes: [NSFontAttributeName: titleFont!],
                                                                      context: nil).size.height
        measuredHeight += titleHeight
        
        // Date
        if let date = displayDateString(photo) {
            let maxDateWidth = width - contentLeftPadding - dateRightPadding
            let dateHeight = NSString(string : date).boundingRect(with: CGSize(width: maxDateWidth, height: CGFloat.greatestFiniteMagnitude),
                                                              options: .usesLineFragmentOrigin,
                                                              attributes: [NSFontAttributeName: dateFont!],
                                                              context: nil).size.height
            measuredHeight += dateHeight + gap
        }
        
        // Descriptions
        if photo.desc != nil {
            let maxDescWidth = width - contentLeftPadding - descRightPadding
            formattedDescText = formattedDescriptionString(photo)
            if formattedDescText != nil {
                descSize = formattedDescText!.boundingRect(with: CGSize(width: maxDescWidth, height: CGFloat.greatestFiniteMagnitude),
                                                         options: .usesLineFragmentOrigin,
                                                         context: nil).size
                measuredHeight += descSize!.height
            }
        }
        
        return measuredHeight
    }
    
    // MARK: - Private
    
    private func formattedDescriptionString(_ photo : PhotoModel) -> NSAttributedString? {
        guard let desc = photo.desc else { return nil }
        
        let descStringWithStyles = NSString(format:"<span style=\"color: #989898; font-family: \(descFont.fontName); font-size: \(descFont.pointSize)\">%@</span>" as NSString, desc) as String
        guard let data = descStringWithStyles.data(using: String.Encoding.utf8) else { return nil }
        
        let options : [String : Any] = [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                              NSCharacterEncodingDocumentAttribute:String.Encoding.utf8.rawValue]
        
        var formattedDesc : NSAttributedString?
        do {
            formattedDesc = try NSAttributedString(data: data, options: options, documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            formattedDesc = nil
        }
        
        return formattedDesc
    }
    
    private func displayDateString(_ photo : PhotoModel) -> String? {
        if photo.creationDate == nil {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: photo.creationDate! as Date)
    }
    
    override func entranceAnimationWillBegin() {
        titleLabel.alpha = 0
        dateLabel.alpha = 0
        descLabel.alpha = 0
        voteButton.alpha = 0
        
        titleLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        dateLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        descLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        voteButton.transform = CGAffineTransform(translationX: 0, y: 30)
    }
    
    override func performEntranceAnimation() {
        UIView .addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 1, animations: { [weak self] in
            self?.titleLabel.alpha = 1
            self?.titleLabel.transform = CGAffineTransform.identity
            self?.voteButton.alpha = 1
            self?.voteButton.transform = CGAffineTransform.identity
        })
        
        UIView .addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1, animations: { [weak self] in
            self?.dateLabel.alpha = 1
            self?.dateLabel.transform = CGAffineTransform.identity
        })
        
        UIView .addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 1, animations: { [weak self] in
            self?.descLabel.alpha = 1
            self?.descLabel.transform = CGAffineTransform.identity
        })
    }
    
    @objc private func voteButtonDidTap(_ tap : UITapGestureRecognizer) {
        voteButton.alpha = 0.5
        voteButton.isUserInteractionEnabled = false
        
        if photo.voted {
            APIService.sharedInstance.deleteVote(photoId: photo.photoId, success: nil, failure: { [weak self] (errorMessage) in
                self?.voteButton.alpha = 1
                self?.voteButton.isUserInteractionEnabled = true
            })
        } else {
            APIService.sharedInstance.votePhoto(photoId: photo.photoId, success: nil, failure: { [weak self] (errorMessage) in
                    self?.voteButton.alpha = 1
                    self?.voteButton.isUserInteractionEnabled = true
            })
        }
    }
    
    // Events
    @objc private func photoVoteDidUpdate(_ notification : Notification) {
        let updatedPhoto = notification.userInfo![StorageServiceEvents.photo] as! PhotoModel
        guard updatedPhoto.photoId == photo.photoId else { return }
        photo.voted = updatedPhoto.voted
    
        voteButton.alpha = 1
        voteButton.isUserInteractionEnabled = true
        
        if photo.voted {
            voteButton.setImage(UIImage(named: "DownVote"), for: .normal)
        } else {
            voteButton.setImage(UIImage(named: "UpVote"), for: .normal)
        }
    }
}
