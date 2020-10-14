//
//  EditProfileHeader.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/10/15.
//

import UIKit

protocol EditProfileHeaderDelegate: class {
    func didTapChangeProfilePhoto()
}

class EditProfileHeader: UIView {
    //MARK: - Properties
    private let user: User
    weak var delegate: EditProfileHeaderDelegate?
    private lazy var profileImgView: UIImageView = {
        let imgView: UIImageView = UIImageView()
        imgView.contentMode = UIImageView.ContentMode.scaleAspectFill
        imgView.layer.masksToBounds = true
        imgView.clipsToBounds = true
        imgView.layer.borderWidth = 3
        imgView.backgroundColor = UIColor.lightGray
        imgView.layer.borderColor = UIColor.white.cgColor
        return imgView
    }()
    private let changePhotoButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Change Profile Photo", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: UIControl.Event.touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        return button
    }()
    //MARK: - LifeCycles
    init(user: User) {
        self.user = user
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.twitterBlue
        
        addSubview(profileImgView)
        profileImgView.center(inView: self, yConstant: -16)
        profileImgView.setDimensions(width: 100, height: 100)
        profileImgView.layer.cornerRadius = 100 / 2
        
        
        addSubview(changePhotoButton)
        changePhotoButton.centerX(inView: self, topAnchor: profileImgView.bottomAnchor, paddingTop: 8)
        
        profileImgView.sd_setImage(with: user.profileImgURL)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    //MARK: - API
    //MARK: - Selectors
    @objc func handleChangeProfilePhoto() {
        delegate?.didTapChangeProfilePhoto()
    }
}
