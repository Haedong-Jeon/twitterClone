//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/24.
//

import UIKit

protocol ProfileHeaderDelegate: class {
    func handleBackButton()
    func handleEditProfileFollow(_ header: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    //MARK: - Properties
    var delegate: ProfileHeaderDelegate?
    private let filterBar: ProfileFilterView = ProfileFilterView()
    var user: User? {
        didSet {
            configure()
        }
    }
    private lazy var profileImgView: UIImageView = {
        let imgView: UIImageView = UIImageView()
        imgView.contentMode = UIImageView.ContentMode.scaleAspectFill
        imgView.setDimensions(width: 80, height: 80)
        imgView.layer.cornerRadius = 80 / 2
        imgView.layer.masksToBounds = true
        imgView.clipsToBounds = true
        imgView.layer.borderWidth = 4
        imgView.backgroundColor = UIColor.lightGray
        imgView.layer.borderColor = UIColor.white.cgColor
        return imgView
    }()
    private lazy var containerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.twitterBlue
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
        backButton.setDimensions(width: 30, height: 30)
        return view
    }()
    private lazy var backButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(UIImage.RenderingMode.alwaysOriginal), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    lazy var editProfileFollowButton: UIButton =  {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Loading", for: UIControl.State.normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(UIColor.twitterBlue, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setDimensions(width: 100, height: 36)
        button.layer.cornerRadius = 36 / 2
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: UIControl.Event.touchUpInside)
        return button
    }()
    private let bioLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 3
        label.text = "this is user bio that will span more than one line for test purposes"
        return label
    }()
    private let fullNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "HAEDONG"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private let userNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "HAEDONG"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        return label
    }()
    private let underLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.twitterBlue
        return view
    }()
    private let followingLabel: UILabel = {
        let label: UILabel = UILabel()
        let followTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    private let followersLabel: UILabel = {
        let label: UILabel = UILabel()
        let followTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    //MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 100)
        addSubview(profileImgView)
        profileImgView.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: -24, paddingLeft: 8)
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
        
        let userDetailStack: UIStackView = UIStackView(arrangedSubviews: [fullNameLabel, userNameLabel, bioLabel])
        userDetailStack.axis = NSLayoutConstraint.Axis.vertical
        userDetailStack.distribution = UIStackView.Distribution.fillProportionally
        userDetailStack.spacing = 4

        addSubview(userDetailStack)
        userDetailStack.anchor(top: profileImgView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        let followStack: UIStackView = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.axis = NSLayoutConstraint.Axis.horizontal
        followStack.spacing = 8
        followStack.distribution = UIStackView.Distribution.fillEqually
        addSubview(followStack)
        followStack.anchor(top: userDetailStack.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        filterBar.delegate = self
        
        addSubview(underLineView)
        underLineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 3, height: 2)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selector
    @objc func handleBackButtonTapped() {
        delegate?.handleBackButton()
    }
    @objc func handleEditProfileFollow() {
        delegate?.handleEditProfileFollow(self)
    }
    @objc func handleFollowersTapped() {
        
    }
    @objc func handleFollowingTapped() {
        
    }
    //MARK: - Helpers
    func configure() {
        guard let user: User = self.user else { return }
        let viewModel: ProfileHeaderViewModel = ProfileHeaderViewModel(user: user)
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: UIControl.State.normal)
        profileImgView.sd_setImage(with: user.profileImgURL)
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followersString
        
        fullNameLabel.text = user.fullName
        userNameLabel.text = viewModel.userNameWithAtMark
    }
}
//MARK: - PRofileFilterViewDelegate
extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else { return }
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underLineView.frame.origin.x = xPosition
        }
    }
}
