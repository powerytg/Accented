//
//  UserProfileViewController.swift
//  Accented
//
//  User profile page
//
//  Created by Tiangong You on 5/27/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import SDWebImage
import GPUImage

class UserProfileViewController: UIViewController, DeckViewControllerDataSource, DeckNavigationBarDelegate {

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var navView: DeckNavigationBar!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var backgroundView: UIImageView!
    
    fileprivate let deckPaddingTop : CGFloat = 150
    fileprivate let avatarSize = 30
    fileprivate var user : UserModel
    fileprivate var loadingView : LoadingViewController?

    var deck : PagerViewController!
    var cards = [UserProfileCardViewController]()
    
    init(user : UserModel) {
        self.user = user
        super.init(nibName: "UserProfileViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the loading progress view
        loadingView = LoadingViewController()
        loadingView!.loadingText = "Retrieving user profile"
        loadingView!.errorText = "Cannot load user profile"
        loadingView!.retryAction = { [weak self] in
            self?.loadUserProfile()
        }
        
        let loadingViewWidth : CGFloat = view.bounds.size.width
        let loadingViewHeight : CGFloat = 140
        loadingView!.view.frame = CGRect(x: 0,
                                         y: view.bounds.size.height / 2 - loadingViewHeight,
                                         width: loadingViewWidth,
                                         height: loadingViewHeight)
        addChildViewController(loadingView!)
        view.addSubview(loadingView!.view)
        loadingView!.didMove(toParentViewController: self)

        // Always refresh the user profile regardless whether it's been loaded previously
        loadUserProfile()
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(userProfileDidUpdate(_:)), name: StorageServiceEvents.userProfileDidUpdate, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func loadUserProfile() {
        let userId = self.user.userId
        APIService.sharedInstance.getUserProfile(userId: userId!, success: nil) { [weak self] (errorMessage) in
            self?.loadingView?.showErrorState()
        }
    }

    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let avatarUrl = DetailUserUtils.preferredAvatarUrl(user) {
            avatarView.sd_setImage(with: avatarUrl)
        }
        
        nameLabel.text = TextUtils.preferredAuthorName(user).uppercased()
        if user.photoCount != nil && user.followersCount != nil {
            subtitleLabel.text = "\(user.photoCount!) photos, \(user.followersCount!) followers"
        } else if user.photoCount != nil {
            subtitleLabel.text = "\(user.photoCount!) photos"
        } else {
            subtitleLabel.text = "@\(user.userName!)"
        }
        
        // Avatar
        avatarView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: avatarSize, height: avatarSize)).cgPath
        avatarView.layer.shadowColor = UIColor.black.cgColor
        avatarView.layer.shadowOpacity = 0.25
        avatarView.layer.shadowRadius = 3
        avatarView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    fileprivate func initializeCards() {
        cards.append(UserAboutSectionViewController(user: user, nibName: "UserAboutSectionViewController"))
        cards.append(UserPhotosSectionViewController(user: user, nibName: "UserPhotosSectionViewController"))
        cards.append(UserFollowersSectionViewController(user: user, nibName: "UserFollowersSectionViewController"))
        
        deck = PagerViewController(cards: cards)
        let screenHeight = UIScreen.main.bounds.height
        addChildViewController(deck)
        view.addSubview(deck.view)
        deck.view.frame = CGRect(x: 0,
                                 y: deckPaddingTop,
                                 width: view.bounds.size.width,
                                 height: screenHeight - deckPaddingTop - 10)
        deck.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        deck.didMove(toParentViewController: self)
        deck.invalidateLayout()
        
        navView.dataSource = self
        navView.delegate = self
    }
    
    // MARK: - DeckViewControllerDataSource
    
    func numberOfCards() -> Int {
        return cards.count
    }
    
    func cardForItemIndex(_ itemIndex: Int) -> CardViewController {
        return cards[itemIndex]
    }
    
    // MARK: - DeckNavigationBarDelegate
    func navButtonSelectedIndexDidChange(fromIndex: Int, toIndex: Int) {
        deck.scrollToItemAtIndex(index: toIndex)
    }
    
    // Events
    @objc fileprivate func userProfileDidUpdate(_ notification : Notification) {
        // Dismiss the loading view
        self.loadingView?.willMove(toParentViewController: nil)
        self.loadingView?.view.removeFromSuperview()
        self.loadingView?.removeFromParentViewController()
        self.loadingView = nil
        
        self.user = StorageService.sharedInstance.getUserProfile(userId: user.userId)!

        // Show the user profile cards
        initializeCards()
        self.view.setNeedsLayout()
        
        // If the user has a cover image, use it in place of default background
        showUserCoverImageIfApplicable()
    }
    
    fileprivate func showUserCoverImageIfApplicable() {
        guard let coverUrlString = user.coverUrl else { return }
        let url = URL(string: coverUrlString)
        guard url != nil else { return }
        
        let downloader = SDWebImageDownloader.shared()
        _ = downloader?.downloadImage(with: url!, options: [], progress: nil) { [weak self] (image, data, error, finished) in
            guard image != nil && finished == true else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.performCoverImageAnimation(image!)
            }
        }
    }
    
    fileprivate func performCoverImageAnimation(_ image : UIImage) {
        let input = PictureInput(image: image.cgImage!)
        let output = PictureOutput()
        
        output.imageAvailableCallback = { outputImage in
            DispatchQueue.main.async { [weak self] in
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                    self?.backgroundView.alpha = 0
                }, completion: { [weak self](finished) in
                    self?.fadeInCoverImage(outputImage)
                })
            }
        }
        
        let saturationFilter = SaturationAdjustment()
        saturationFilter.saturation = 0.4

        input --> saturationFilter --> output
        input.processImage(synchronously: true)
    }
    
    fileprivate func fadeInCoverImage(_ image : UIImage) {
        backgroundView.image = image
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.backgroundView.alpha = 0.4
            
            }, completion: { [weak self] (finished) in
                // Since we now use a full screen user cover image, we must adjust text clarity
                self?.adjustTextClarity()
        })
    }
    
    fileprivate func adjustTextClarity() {
        navView.adjustTextClarity()
        
        for card in cards {
            card.adjustTextClarity()
        }
    }
}
