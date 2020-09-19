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
    
    private lazy var emailContainerView: UIView = {
        let view: UIView = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let imageView: UIImageView = UIImageView()
        view.addSubview(imageView)
        imageView.image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        imageView.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        imageView.setDimensions(width: 24, height: 24)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view: UIView = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let imageView: UIImageView = UIImageView()
        view.addSubview(imageView)
        imageView.image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        imageView.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        imageView.setDimensions(width: 24, height: 24)
        return view
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
        
        let stack: UIStackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView])
        stack.axis = NSLayoutConstraint.Axis.vertical
        stack.spacing = 8
        
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
    }
}
