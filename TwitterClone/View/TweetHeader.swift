//
//  TweetHeader.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/28.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    //MARK: - Properties
    private lazy var profileImgView: UIImageView = {
        let imgView: UIImageView = UIImageView()
        imgView.contentMode = UIImageView.ContentMode.scaleAspectFill
        imgView.setDimensions(width: 48, height: 48)
        imgView.layer.cornerRadius = 48 / 2
        imgView.layer.masksToBounds = true
        imgView.backgroundColor = UIColor.twitterBlue
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleProfileImgTapped))
        imgView.addGestureRecognizer(tap)
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    private let fullNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "HAEDONG"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    private let userNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "HAEDONG"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        return label
    }()
    private let captionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "TEST CAPTION"
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    private let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.left
        label.text = "6:30 PM - 1/28/2020"
        return label
    }()
    private lazy var optionButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.tintColor = UIColor.lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(showActionSheet), for: UIControl.Event.touchUpInside)
        return button
    }()
    private lazy var statsView: UIView = {
        let view: UIView = UIView()
        let firstDivider: UIView = UIView()
        firstDivider.backgroundColor = UIColor.systemGroupedBackground
        
        view.addSubview(firstDivider)
        firstDivider.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        let labelStack: UIStackView = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        labelStack.axis = NSLayoutConstraint.Axis.horizontal
        labelStack.spacing = 12
        
        view.addSubview(labelStack)
        labelStack.centerY(inView: view)
        labelStack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let secondDivider: UIView = UIView()
        secondDivider.backgroundColor = UIColor.systemGroupedBackground
        
        view.addSubview(secondDivider)
        secondDivider.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        return view
    }()
    private lazy var retweetsLabel: UILabel = {
        var label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0 likes"
        return label
    }()
    private lazy var likesLabel: UILabel = {
        var label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0 likes"
        return label
    }()
    //MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelStack: UIStackView = UIStackView(arrangedSubviews: [fullNameLabel, userNameLabel])
        labelStack.axis = NSLayoutConstraint.Axis.vertical
        labelStack.spacing = -5
        
        let userInfoStack: UIStackView = UIStackView(arrangedSubviews: [profileImgView, labelStack])
        userInfoStack.axis = NSLayoutConstraint.Axis.horizontal
        userInfoStack.spacing = 12
        
        addSubview(userInfoStack)
        userInfoStack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: userInfoStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 16)
        
        addSubview(optionButton)
        optionButton.centerY(inView: userInfoStack)
        optionButton.anchor(right: rightAnchor, paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, height: 40)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    //MARK: - API
    //MARK: - Selectors
    @objc func handleProfileImgTapped() {
    }
    @objc func showActionSheet() {
        
    }
}
