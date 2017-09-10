//
//  NavigationService.swift
//  Accented
//
//  Created by You, Tiangong on 7/11/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class NavigationService: NSObject, UINavigationControllerDelegate {

    // root navigation controller
    weak private var rootNavigationController : UINavigationController?
    
    // Singleton instance
    static let sharedInstance = NavigationService()
    
    private override init() {
        // Do nothing
    }

    func initWithRootNavigationController(_ navigationController : UINavigationController) {
        self.rootNavigationController = navigationController
        rootNavigationController?.delegate = self
    }
    
    func navigateToDetailPage(_ context : DetailNavigationContext) {
        let detailVC = DetailViewController(context: context)
        rootNavigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push && toVC is DetailViewController {
            let detailVC = toVC as! DetailViewController
            return DetailPresentationController(photo : detailVC.photo, sourceImageView: detailVC.entranceAnimationImageView, fromViewController: fromVC, toViewController: detailVC)
        } else {
            return nil
        }
    }
    
    func topViewController() -> UIViewController? {
        return rootNavigationController?.topViewController
    }
    
    func navigateToCommentsPage(_ photo : PhotoModel) {
        let vc = DetailCommentsViewController()
        vc.photo = photo
        rootNavigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToSearchResultPage(keyword : String) {
        let vc = SearchResultViewController(keyword: keyword)
        rootNavigationController?.pushViewController(vc, animated: true)
    }

    func navigateToSearchResultPage(tag : String) {
        let vc = TagSearchResultViewController(tag: tag)
        rootNavigationController?.pushViewController(vc, animated: true)
    }

    func navigateToUserProfilePage(user : UserModel) {
        let vc = UserProfileViewController(user: user)
        rootNavigationController?.pushViewController(vc, animated: true)
    }

    func navigateToUserStreamPage(user : UserModel) {
        let vc = UserPhotosViewController(user: user)
        rootNavigationController?.pushViewController(vc, animated: true)
    }

    func navigateToCamera() {
        let vc = PearlCamViewController()
        rootNavigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToUserGalleryListPage(user : UserModel) {
        let vc = UserGalleryListViewController(user: user)
        rootNavigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToGalleryPage(gallery : GalleryModel) {
        let vc = UserGalleryViewController(userId : gallery.userId, gallery: gallery)
        rootNavigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToUserFriendsPage(user : UserModel) {
        let vc = UserFriendsViewController(user: user)
        rootNavigationController?.pushViewController(vc, animated: true)
    }

    func navigateToUserFriendsPhotosPage(user : UserModel) {
        let vc = UserFriendsPhotosViewController(user: user)
        rootNavigationController?.pushViewController(vc, animated: true)
    }

    func navigateToSearch(from: UIViewController) {
        let searchViewController = SearchViewController()
        from.present(searchViewController, animated: true, completion: nil)
    }
    
    func navigateToAboutPage() {
        let vc = AboutViewController(nibName: "AboutViewController", bundle: nil)
        rootNavigationController?.pushViewController(vc, animated: true)
    }
    
    func popToRootController(animated : Bool) {
        _ = rootNavigationController?.popToRootViewController(animated: animated)
    }
    
    func signout() {
        NotificationCenter.default.post(name: AuthenticationService.userDidSignOut, object: nil)
    }
}
