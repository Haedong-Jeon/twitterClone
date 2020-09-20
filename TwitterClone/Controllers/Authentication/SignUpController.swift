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
        present(imagePicker, animated: false, completion: nil)
    }
    @objc func handleRegistration() {
        guard let email: String = emailTextField.text else { return }
        guard let password: String = passwordTextField.text else { return }
        guard let fullName: String = fullNameTextField.text else { return }
        guard let userName: String = userNameTextField.text else { return }
        guard let profileImage: UIImage = self.profileImage else {
            showSignUpResultMessage(title: "Err", Msg: "please, select profile image")
            return
        }
        guard let imageData: Data = profileImage.jpegData(compressionQuality: 0.3) else { return }
        let profileImgfileName: String = NSUUID().uuidString
        let userProfileImgRef = STORAGE_REF_PROFILE_IMGS.child(profileImgfileName)
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.showSignUpResultMessage(title: "ERR in creating User", Msg: "\(error.localizedDescription)")
                return
            }
            userProfileImgRef.putData(imageData, metadata: nil) { (meta, error) in
                if let error = error {
                    self.showSignUpResultMessage(title: "ERR in upload image", Msg: "\(error.localizedDescription)")
                }
                userProfileImgRef.downloadURL { (url, error) in
                    guard let profileImgUrl: String = url?.absoluteString else { return }
                    if let error = error {
                        self.showSignUpResultMessage(title: "Err", Msg: "\(error.localizedDescription)")
                        return
                    }
                    guard let uid: String = result?.user.uid else { return }
                    let values: [String: Any] = ["email": email, "userName": userName, "fullName": fullName, "profileImgURL": profileImgUrl]
                    DB_REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                        self.showSignUpResultMessage(title: "Success", Msg: "sign up Complete")
                    }
                }
            }
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
    func showSignUpResultMessage(title: String, Msg: String) {
        let alertController: UIAlertController = UIAlertController(title: title, message: Msg, preferredStyle: UIAlertController.Style.alert)
        let alertActionMsg: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(alertActionMsg)
        self.present(alertController, animated: false, completion: nil)
    }
}
