//
//  NotificationCell.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/10/07.
//

import UIKit

protocol NotificationCellDelegate: class {
    func didTapProfileImg(_ cell: NotificationCell)
    func didTapFollow(_ cell: NotificationCell)
}
class NotificationCell: UITableViewCell {
    //MARK: - Properties
    var notification: Notification? {
        didSet {
            configure()
        }
    }
    weak var delegate: NotificationCellDelegate?
    private lazy var profileImgView: UIImageView = {
        let imgView: UIImageView = UIImageView()
        imgView.contentMode = UIImageView.ContentMode.scaleAspectFill
        imgView.setDimensions(width: 40, height: 40)
        imgView.layer.cornerRadius = 40 / 2
        imgView.layer.masksToBounds = true
        imgView.backgroundColor = UIColor.twitterBlue
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleProfileImgTapped))
        imgView.addGestureRecognizer(tap)
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    private lazy var followButton: UIButton = {
        var button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Loading", for: UIControl.State.normal)
        button.setTitleColor(UIColor.twitterBlue, for: UIControl.State.normal)
        button.backgroundColor = UIColor.white
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleFollowTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    let notificationLabel: UILabel = {
        var label: UILabel = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "SOME TEST TEXT FOR NOTIFICATION"
        return label
    }()
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack: UIStackView = UIStackView(arrangedSubviews: [profileImgView, notificationLabel])
        stack.spacing = 8
        stack.alignment = UIStackView.Alignment.center
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        stack.anchor(right: rightAnchor, paddingRight: 12)
        
        addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.setDimensions(width: 92, height: 32)
        followButton.layer.cornerRadius = 32 / 2
        followButton.anchor(right: rightAnchor, paddingRight: 12)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func configure() {
        guard let notification: Notification = notification else { return }
        let viewModel: NotificationViewModel = NotificationViewModel(notification: notification)
        
        profileImgView.sd_setImage(with: viewModel.profileImgURL)
        notificationLabel.attributedText = viewModel.notificationText
        
        followButton.isHidden = viewModel.shouldHideFollowButton
        followButton.setTitle(viewModel.followButtonText, for: UIControl.State.normal)
        
    }
    //MARK: - Selectors
    @objc func handleProfileImgTapped() {
        delegate?.didTapProfileImg(self)
    }
    @objc func handleFollowTapped() {
        delegate?.didTapFollow(self)
    }
}
