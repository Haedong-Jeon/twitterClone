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
        feed.tabBarItem.image = UIImage(named: "home_unselected")
        
        let explore: ExploreController = ExploreController()
        explore.tabBarItem.image = UIImage(named: "search_unselected")
        
        let notifications: NotificationController = NotificationController()
        notifications.tabBarItem.image = UIImage(named:"search_unselected")
        
        let conversations: ConversationController = ConversationController()
        conversations.tabBarItem.image = UIImage(named:"search_unselected")
        
        viewControllers = [feed, explore, notifications, conversations]
    }
}
