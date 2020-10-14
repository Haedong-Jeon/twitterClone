//
//  EditProfileController.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/10/15.
//

import UIKit
private let reuseIdentifier: String = "EditProfileCellReuse"

class EditProfileController: UITableViewController {
    //MARK: -Properties
    private var user: User
    private lazy var headerView: EditProfileHeader = EditProfileHeader(user: user)
    //MARK: - LifeCycles
    init(user: User) {
        self.user = user
        super.init(style: UITableView.Style.plain)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
    }
    //MARK: - Helpers
    func configureNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.twitterBlue
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(handleDone))
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        headerView.delegate = self
        
        tableView.tableFooterView = UIView()
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    //MARK: - API
    //MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    @objc func handleDone() {
    }
}

extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: EditProfileCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? EditProfileCell else {
            return UITableViewCell()
        }
        return cell
    }
}

extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangeProfilePhoto() {
        
    }
}

extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else { return 0 }
        return option == EditProfileOptions.bio ? 100 : 48
    }
}
