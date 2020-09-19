//
//  LoginController.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/19.
//

import UIKit

class LoginController: UIViewController {
    //MARK: - properties
    private let logoImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "TwitterLogo")
        return imageView
    }()
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - Selectors
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = UIColor.twitterBlue
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
        logoImageView.setDimensions(width: 150, height: 150)
    }
}
