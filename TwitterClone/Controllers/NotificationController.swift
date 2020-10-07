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
        }
    }
}
extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: NotificationCell = tableView.dequeueReusableCell(withIdentifier: notificationIdentifier) as? NotificationCell else {
            return UITableViewCell()
        }
        return cell
    }
}
