//
//  ActionSheetLauncher.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/29.
//

import Foundation
import UIKit

private let reuseIdentifier: String = "actionSheetCell"
protocol ActionSheetLauncherDelegate: class {
    func didSelect(options: ActionSheetOptions)
}

class ActionSheetLauncher: NSObject {
    //MARK: - Properties
    weak var delegate: ActionSheetLauncherDelegate?
    private let user: User
    private let tableView: UITableView = UITableView()
    private var window: UIWindow?
    private var tableViewHeight: CGFloat?
    private lazy var viewModel: ActionSheetViewModel = ActionSheetViewModel(user: self.user)
    private lazy var blackView: UIView = {
        let view: UIView = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap: UIGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        return view
    }()
    private lazy var cancelButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Cancel", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.backgroundColor = UIColor.systemBackground
        button.addTarget(self, action: #selector(handleDismissal), for: UIControl.Event.touchUpInside)
        return button
    }()
    private lazy var footerView: UIView = {
        let view: UIView = UIView()
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 12, paddingRight: 12)
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50 / 2
        return view
    }()
    //MARK: - LifeCycles
    init(user: User) {
        self.user = user
        super.init()
    }
    //MARK: - Helpers
    func showTableView(_ shouldShow: Bool) {
        guard let window = window else { return }
        guard let height = self.tableViewHeight else { return }
        
        let y = shouldShow ? window.frame.height - height : window.frame.height
        tableView.frame.origin.y = y
    }
    func show() {
        configureTableView()
        
        let height: CGFloat = CGFloat(viewModel.options.count * 60) + 100
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
        self.window =  window
        
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(self.tableView)
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width , height: height)
        self.tableViewHeight = height
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.showTableView(true)
        }
    }
    func configureTableView() {
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 60
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    //MARK: - API
    //MARK: - Selector
    @objc func handleDismissal() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 300
        }
    }
}
//MARK: - tableView DataSource
extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ActionSheetCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ActionSheetCell else {
            return UITableViewCell()
        }
        cell.options = viewModel.options[indexPath.row]
        return cell
    }
}
//MARK: - tableView Delegate
extension ActionSheetLauncher: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let options: ActionSheetOptions = viewModel.options[indexPath.row]
        UIView.animate(withDuration: 0.5 ,animations: {
            self.blackView.alpha = 0
            self.showTableView(false)
        }) { _ in
            self.delegate?.didSelect(options: options)
        }
    }
}
