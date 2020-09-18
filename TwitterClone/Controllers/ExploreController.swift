//
//  ExploreController.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/18.
//

import UIKit

class ExploreController: UIViewController {
    //MARK: - Properties
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "Explore"
    }
}
