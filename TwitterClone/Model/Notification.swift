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
    var tweetID: String?
    var tweet: Tweet?
    var timeStamp: Date!
    var type: NotificationType!
    var user: User

    init(user: User, dictionary: [String: AnyObject]) {
        self.user = user
        if let tweetID = dictionary["tweetID"] as? String {
            self.tweetID = tweetID
        }
        if let timeStamp = dictionary["timeStamp"] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timeStamp)
        }
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
