//
//  UploadTweetsController.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/22.
//

import UIKit

class UploadTweetsController: UIViewController {
    //MARK: - properties
    private let user: User
    private lazy var actionButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = UIColor.twitterBlue
        button.setTitle("tweet", for: UIControl.State.normal)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        
        button.addTarget(self, action: #selector(handleUploadTweet), for: UIControl.Event.touchUpInside)
        return button
    }()
    private let profileImgView: UIImageView = {
        let imgView: UIImageView = UIImageView()
        imgView.contentMode = UIImageView.ContentMode.scaleAspectFill
        imgView.setDimensions(width: 48, height: 48)
        imgView.layer.cornerRadius = 48 / 2
        imgView.layer.masksToBounds = true
        return imgView
    }()
    private let captionTextView: CaptionTextView = CaptionTextView()
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selector
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    @objc func handleUploadTweet() {
        guard let caption: String = captionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption) { (error, ref) in
            if let error = error {
                print("DEBUG: fail to upload tweet - \(error)")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    //MARK: - API
    //MARK: - Helper
    func configureUI() {
        view.backgroundColor = UIColor.white
        configureNavigationBar()
        let stack: UIStackView = UIStackView(arrangedSubviews: [profileImgView, captionTextView])
        stack.axis = NSLayoutConstraint.Axis.horizontal
        stack.spacing = 12
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        profileImgView.sd_setImage(with: user.profileImgURL, completed: nil)

    }
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}

