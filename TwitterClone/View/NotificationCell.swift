//
//  NotificationCell.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/10/07.
//

import UIKit

class NotificationCell: UITableViewCell {
    //MARK: - Properties
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
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    //MARK: - Selectors
    @objc func handleProfileImgTapped() {
        
    }
}
