//
//  UserCell.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/26.
//

import UIKit

class UserCell: UITableViewCell {
    //MARK: - Properties
    var user: User? {
        didSet {
            configure()
        }
    }
    private lazy var profileImgView: UIImageView = {
        let imgView: UIImageView = UIImageView()
        imgView.contentMode = UIImageView.ContentMode.scaleAspectFill
        imgView.setDimensions(width: 40, height: 40)
        imgView.layer.cornerRadius = 40 / 2
        imgView.layer.masksToBounds = true
        imgView.backgroundColor = UIColor.twitterBlue
        return imgView
    }()
    private let userNameLabel: UILabel = {
        var uiLabel: UILabel = UILabel()
        uiLabel.font = UIFont.boldSystemFont(ofSize: 14)
        uiLabel.text = "some Text"
        return uiLabel
    }()
    private let fullNameLabel: UILabel = {
        var uiLabel: UILabel = UILabel()
        uiLabel.font = UIFont.systemFont(ofSize: 14)
        uiLabel.text = "some Text"
        return uiLabel
    }()
    //MARK: - LifeCycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        
        addSubview(profileImgView)
        profileImgView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack: UIStackView = UIStackView(arrangedSubviews: [userNameLabel, fullNameLabel])
        stack.axis = NSLayoutConstraint.Axis.vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: profileImgView, leftAnchor: profileImgView.rightAnchor, paddingLeft: 12)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func configure() {
        guard let user: User = user else { return }
        profileImgView.sd_setImage(with: user.profileImgURL)
        userNameLabel.text = user.userName
        fullNameLabel.text = user.fullName
    }
}
