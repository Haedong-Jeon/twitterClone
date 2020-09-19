//
//  SignUpController.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/19.
//

import UIKit

class SignUpController: UIViewController {
    //MARK: - properties
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - Selectors
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = UIColor.twitterBlue
    }
}
