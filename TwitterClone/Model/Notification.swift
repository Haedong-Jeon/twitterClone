//
//  Notification.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/10/07.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}
struct Notification {
    let tweetID: String?
    let tweet: Tweet?
    var timeStamp: Date!
    var type: NotificationType!
    let user: User

    init(user: User, tweet: Tweet?, dictionary: [String: AnyObject]) {
        self.user = user
        self.tweet = tweet
        
        self.tweetID = dictionary["tweetID"] as? String ?? ""
        
        if let timeStamp = dictionary["timeStamp"] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timeStamp)
        }
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
