//
//  ExploreController.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/18.
//

import UIKit

private let tableCellIdentifier: String = "talbeCellReuse"

class ExploreController: UITableViewController {
    //MARK: - Properties
    private var users: [User] = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
    }
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: tableCellIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    //MARK: - API
    func fetchUsers() {
        UserService.shared.fetchUsers { users in
            self.users = users
        }
    }
}
extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UserCell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier) as? UserCell else {
            return UITableViewCell()
        }
        cell.user = users[indexPath.row]
        return cell
    }
}
