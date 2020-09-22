//
//  MainTabController.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/18.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    //MARK: - Properties
    var user: User? {
        didSet {
            guard let nav: UINavigationController = viewControllers?[0] as? UINavigationController else { return }
            guard let feed: FeedController = nav.viewControllers.first as? FeedController else { return }
            
            feed.user = user
        }
    }
    let actionButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.backgroundColor = UIColor.twitterBlue
        button.tintColor = UIColor.white
        button.setImage(UIImage(named: "new_tweet"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        userLogOut()
        authenticateUserAndConfigureUI()
    }
    //MARK: - API
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navigation: UINavigationController = UINavigationController(rootViewController: LoginController())
                navigation.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self.present(navigation, animated: true, completion: nil)
            }
        } else {
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    func userLogOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Failed to log out \(error.localizedDescription)")
        }
    }
    func fetchUser() {
        UserService.shared.fetchUser { user in
            self.user = user
        }
    }
    
    //MARK: - Selectors
    @objc func actionButtonTapped() {
        let nav: UINavigationController = UINavigationController(rootViewController: UploadTweetsController())
        present(nav, animated: true, completion: nil)
    }
    //MARK: - Helpers
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    func configureViewControllers() {
        let feed: FeedController = FeedController()
        let feedNav: UINavigationController = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)

        let explore: ExploreController = ExploreController()
        let exploreNav: UINavigationController = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)

        let notifications: NotificationController = NotificationController()
        let notificationsNav: UINavigationController = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notifications)
        
        let conversations: ConversationController = ConversationController()
        let conversationsNav: UINavigationController = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversations)
        
        viewControllers = [feedNav, exploreNav, notificationsNav, conversationsNav]
    }
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav: UINavigationController = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = UIColor.white
        return nav
    }
}
