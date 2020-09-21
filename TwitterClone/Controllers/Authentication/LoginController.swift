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
        let view: UIView = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"), textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view: UIView = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        return view
    }()
    private let emailTextField: UITextField = {
        let textField: UITextField = Utilities().textField(withPlaceholder: "Email")
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField: UITextField = Utilities().textField(withPlaceholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    private let loginButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Log-in", for: UIControl.State.normal)
        button.setTitleColor(UIColor.twitterBlue, for: UIControl.State.normal)
        button.backgroundColor = UIColor.white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: UIControl.Event.touchUpInside)
        return button
    }()
    private let dontHaveAccountButton: UIButton = {
        let button: UIButton = Utilities().attributedButton("Don't have account?", " Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: UIControl.Event.touchUpInside)
        return button
    }()
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - Selectors
    @objc func handleLogin() {
        guard let email: String = emailTextField.text else { return }
        guard let password: String = passwordTextField.text else { return }
        AuthService.shared.userLogIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Error in handle log in - \(error.localizedDescription)")
                return
            }
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
            guard let tab: MainTabController = window.rootViewController as? MainTabController else { return }
            
            tab.authenticateUserAndConfigureUI()
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func handleShowSignUp() {
        let signUpController: UIViewController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = UIColor.twitterBlue
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
        logoImageView.setDimensions(width: 150, height: 150)
        
        let stack: UIStackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = NSLayoutConstraint.Axis.vertical
        stack.spacing = 20
        stack.distribution = UIStackView.Distribution.fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 40, paddingRight: 40)
    }
}
