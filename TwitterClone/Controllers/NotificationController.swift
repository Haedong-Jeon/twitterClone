//
//  NotificationController.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/18.
//

import UIKit
private let notificationIdentifier: String = "notificationIdentifier"

class NotificationController: UITableViewController {
    //MARK: - Properties
    private var notifications: [Notification] = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = UIBarStyle.default
    }
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "Notifications"
        tableView.register(NotificationCell.self, forCellReuseIdentifier: notificationIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    //MARK: - API
    func fetchNotifications() {
        NotificationService.shared.fetchNotifications { notifications in
            self.notifications = notifications
            
            for(index, notification) in notifications.enumerated() {
                if case .follow = notification.type {
                    let user: User = notification.user
                    UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                        self.notifications[index].user.isFollowed = isFollowed
                    }
                }
            }
        }
    }
}
//MARK: - tableView delegate
extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: NotificationCell = tableView.dequeueReusableCell(withIdentifier: notificationIdentifier) as? NotificationCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.notification = notifications[indexPath.row]
        return cell
    }
}
extension NotificationController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification: Notification = notifications[indexPath.row]
        guard let tweetID: String = notification.tweetID else { return }
        TweetService.shared.fetchTweet(withTweetID: tweetID) { tweet in
            let controller: TweetController = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
//MARK: - notification cell delegate
extension NotificationController: NotificationCellDelegate {
    func didTapFollow(_ cell: NotificationCell) {
        
    }
    func didTapProfileImg(_ cell: NotificationCell) {
        guard let user: User = cell.notification?.user else { return }
        
        let controller: ProfileController = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
