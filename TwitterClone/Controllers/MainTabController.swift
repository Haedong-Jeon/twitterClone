//
//  MainTabController.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/18.
//

import UIKit

class MainTabController: UITabBarController {
    //MARK: - Properties
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    //MARK: - Helpers
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
