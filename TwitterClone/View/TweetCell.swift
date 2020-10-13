//
//  TweetCell.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/23.
//

import UIKit

protocol TweetCellDelegateProtocol: class {
    func handleProfileImgTapped(_ cell: TweetCell)
    func handleReplyTapped(_ cell: TweetCell)
    func handleLikeTapped(_ cell: TweetCell)
}

class TweetCell: UICollectionViewCell {
    weak var delegate: TweetCellDelegateProtocol?
    
    var tweet: Tweet? {
        didSet {
            configure()
        }
    }
    //MARK: - properties
    private let infoLabel: UILabel = UILabel()
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
    private let captionLabel: UILabel = {
        var uiLabel: UILabel = UILabel()
        uiLabel.font = UIFont.systemFont(ofSize: 14)
        uiLabel.numberOfLines = 0
        uiLabel.text = "this is sample Text"
        return uiLabel
    }()
    private lazy var commentButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "comment"), for: UIControl.State.normal)
        button.tintColor = UIColor.darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleCommentTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    private lazy var retweetButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "retweet"), for: UIControl.State.normal)
        button.tintColor = UIColor.darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleRetweetTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    private lazy var likeButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "like"), for: UIControl.State.normal)
        button.tintColor = UIColor.darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleLikeTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    private lazy var shareButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(named: "share"), for: UIControl.State.normal)
        button.tintColor = UIColor.darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleShareTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    private let replyLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    //MARK: - Selectors
    @objc func handleCommentTapped() {
        delegate?.handleReplyTapped(self)
    }
    @objc func handleRetweetTapped() {
        
    }
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(self)
    }
    @objc func handleShareTapped() {
        
    }
    @objc func handleProfileImgTapped() {
        delegate?.handleProfileImgTapped(self)
    }
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white

        let captionStack: UIStackView = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        captionStack.axis = NSLayoutConstraint.Axis.vertical
        captionStack.distribution = UIStackView.Distribution.fillProportionally
        captionStack.spacing = 4
        
        let imgCaptionStack: UIStackView = UIStackView(arrangedSubviews: [profileImgView, captionStack])
        imgCaptionStack.distribution = UIStackView.Distribution.fillProportionally
        imgCaptionStack.spacing = 12
        imgCaptionStack.alignment = UIStackView.Alignment.leading
        
        let stack: UIStackView = UIStackView(arrangedSubviews: [replyLabel, imgCaptionStack])
        stack.axis = NSLayoutConstraint.Axis.vertical
        stack.spacing = 8
        stack.distribution = UIStackView.Distribution.fillProportionally
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingRight: 12)
        

        let buttonStack: UIStackView = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        buttonStack.axis = NSLayoutConstraint.Axis.horizontal
        buttonStack.spacing = 72
        addSubview(buttonStack)
        buttonStack.centerX(inView: self)
        buttonStack.anchor(bottom: self.bottomAnchor, paddingBottom: 8)
        let underLineView: UIView = UIView()
        underLineView.backgroundColor = UIColor.systemGroupedBackground
        addSubview(underLineView)
        underLineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selector
    //MARK: - Helpers
    func configure() {
        guard let tweet: Tweet = self.tweet else { return }
        let viewModel: TweetViewModel = TweetViewModel(tweet: tweet)
        profileImgView.sd_setImage(with: viewModel.profileImgURL)
        
        infoLabel.attributedText = viewModel.userInfoText
        captionLabel.text = tweet.caption
        
        likeButton.setImage(viewModel.likeButtonImg, for: UIControl.State.normal)
        likeButton.tintColor = viewModel.likeButtonTintColor
        
        replyLabel.isHidden = viewModel.shouldHideReplyLabel
        replyLabel.text = viewModel.replyText
    }
}
