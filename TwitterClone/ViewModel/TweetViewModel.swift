//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/23.
//

import UIKit

struct TweetViewModel {
    let tweet: Tweet
    let user: User
    var timeStamp: String {
        let formatter: DateComponentsFormatter = DateComponentsFormatter()
        formatter.allowedUnits = [NSCalendar.Unit.second, NSCalendar.Unit.minute, NSCalendar.Unit.hour, NSCalendar.Unit.day, NSCalendar.Unit.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = DateComponentsFormatter.UnitsStyle.abbreviated
        let now: Date = Date()
        return formatter.string(from: tweet.timeStamp, to: now)!
    }
    var headerTimeStamp: String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a · MM/dd/yyyy"
        return dateFormatter.string(from: tweet.timeStamp)
    }
    var retweetsAttributedString: NSAttributedString? {
        return attributedText(withValue: tweet.retweetCount, text: " retweets")
    }
    var likesAttributedString: NSAttributedString? {
        return attributedText(withValue: tweet.likes, text: " likes")
    }
    var likeButtonTintColor: UIColor {
        return tweet.didLike ? UIColor.red : UIColor.lightGray
    }
    var likeButtonImg: UIImage {
        let imgName = tweet.didLike ? "like_filled" : "like"
        return UIImage(named: imgName)!
    }
    var profileImgURL: URL {
        (tweet.user?.profileImgURL)!
    }
    var userInfoTextString: String {
        return "@\(user.userName)"
    }
    var userInfoText: NSAttributedString {
        let title: NSMutableAttributedString = NSMutableAttributedString(string: user.fullName, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: "\(user.userName)" ,attributes:[.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: "· \(timeStamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }
    var shouldHideReplyLabel: Bool {
        return !tweet.isReply
    }
    var replyText: String? {
        guard let replyTarget: String = tweet.replyTo else { return nil }
        return "→ reply to \(replyTarget)"
    }
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user!
    }
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle: NSMutableAttributedString = NSMutableAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize:14)])
        
        attributedTitle.append(NSAttributedString(string: "\(text)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel: UILabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
