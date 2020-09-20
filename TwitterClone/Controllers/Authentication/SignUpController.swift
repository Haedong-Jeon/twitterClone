//
//  SignUpController.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/19.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    //MARK: - properties
    private let imagePicker: UIImagePickerController = UIImagePickerController()
    private let plusPhotoButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(named:"plus_photo"), for: UIControl.State.normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: UIControl.Event.touchUpInside)
        return button
    }()
    private var profileImage: UIImage?
    private lazy var emailContainerView: UIView = {
        let view: UIView = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"), textField: emailTextField)
        return view
    }()
    private lazy var passwordContainerView: UIView = {
        let view: UIView = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        return view
    }()
    private lazy var fullNameContainerView: UIView = {
        let view: UIView = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"), textField: fullNameTextField)
        return view
    }()
    private lazy var userNameContainerView: UIView = {
        let view: UIView = Utilities().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: userNameTextField)
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
    private let fullNameTextField: UITextField = {
        let textField: UITextField = Utilities().textField(withPlaceholder: "full name")
        return textField
    }()
    private let userNameTextField: UITextField = {
        let textField: UITextField = Utilities().textField(withPlaceholder: "user name")
        return textField
    }()
    private let alreadyHaveAccountButton: UIButton = {
        let button: UIButton = Utilities().attributedButton("already have account?", " Log in")
        button.addTarget(self, action: #selector(handleShowLogin), for: UIControl.Event.touchUpInside)
        return button
    }()
    private let registrationButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Sign Up", for: UIControl.State.normal)
        button.setTitleColor(UIColor.twitterBlue, for: UIControl.State.normal)
        button.backgroundColor = UIColor.white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleRegistration), for: UIControl.Event.touchUpInside)
        return button
    }()
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - Selectors
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    @objc func handleAddProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    @objc func handleRegistration() {
        guard let email: String = emailTextField.text else { return }
        guard let password: String = passwordTextField.text else { return }
        guard let fullName: String = fullNameTextField.text else { return }
        guard let userName: String = userNameTextField.text else { return }
        guard let profileImage: UIImage = self.profileImage else {
            let alert: UIAlertController = UIAlertController(title: "Error", message: "please selecte profile img", preferredStyle: .alert)
            let actionButton: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(actionButton)
            self.present(alert, animated: false, completion: nil)
            return
        }
        let userCredential: AuthCredentials = AuthCredentials(email: email, password: password, fullName: fullName, userName: userName, profileImage: profileImage)
        AuthService.shared.registerUser(credential: userCredential) { (error, ref) in
            if let error = error {
                print("DEBUG: error in update user value in sign up - \(error.localizedDescription)")
            }
            
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
            guard let tab: MainTabController = window.rootViewController as? MainTabController else { return }
            
            tab.authenticateUserAndConfigureUI()
            self.dismiss(animated: true, completion: nil)
        }
    }
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = UIColor.twitterBlue
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 40, paddingRight: 40)
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
        plusPhotoButton.setDimensions(width: 128, height: 128)
        
        let stack: UIStackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, fullNameContainerView, userNameContainerView, registrationButton])
        stack.axis = NSLayoutConstraint.Axis.vertical
        stack.spacing = 20
        stack.distribution = UIStackView.Distribution.fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 40, paddingRight: 40)
    }
}
//MARK: - UIImagePickerControllerDelegate
extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.profileImage = profileImage
        
        plusPhotoButton.setImage(profileImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: UIControl.State.normal)
        plusPhotoButton.layer.cornerRadius = 128 / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = UIImageView.ContentMode.scaleAspectFill
        plusPhotoButton.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
}
