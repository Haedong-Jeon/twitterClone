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
    private let searchController: UISearchController = UISearchController(searchResultsController: nil)
    private var filteredUsers: [User] = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
        fetchUsers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = UIBarStyle.default
        navigationController?.navigationBar.isHidden = false
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
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for user..."
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}
//MARK: - UITableView Delegate / DataSource
extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UserCell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier) as? UserCell else {
            return UITableViewCell()
        }
        let user: User = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user: User = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let profileController: ProfileController = ProfileController(user: user)
        navigationController?.pushViewController(profileController, animated: true)
    }
}
extension ExploreController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText: String  = searchController.searchBar.text else { return }
        
        filteredUsers = users.filter({
            $0.userName.contains(searchText)
        })
    }
}
