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
    var profileImgURL: URL {
        (tweet.user?.profileImgURL)!
    }
    var userInfoText: NSAttributedString {
        let title: NSMutableAttributedString = NSMutableAttributedString(string: user.fullName, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: "\(user.userName)" ,attributes:[.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: "· \(timeStamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user!
    }
}
