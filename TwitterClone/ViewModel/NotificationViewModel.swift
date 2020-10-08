//
//  NotificationViewModel.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/10/08.
//

import UIKit

struct NotificationViewModel {
    private let notification: Notification
    private let notificationType: NotificationType
    private let user: User

    var profileImgURL: URL
    var timeStampString: String? {
        let formatter: DateComponentsFormatter = DateComponentsFormatter()
        formatter.allowedUnits = [NSCalendar.Unit.second, NSCalendar.Unit.minute, NSCalendar.Unit.hour, NSCalendar.Unit.day, NSCalendar.Unit.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = DateComponentsFormatter.UnitsStyle.abbreviated
        let now: Date = Date()
        return formatter.string(from: notification.timeStamp, to: now)!
    }
    
    var notificationMsg: String {
        switch notificationType {
        case .follow:
            return "Starting follow view"
        case .like:
            return "liked your tweet"
        case .reply:
            return "reply to your tweet"
        case .retweet:
            return "retweeted your tweet"
        case .mention:
            return "mentioned your tweet"
        }
    }
    var notificationText: NSAttributedString? {
        guard let timeStamp = timeStampString else { return nil }
        let attributedText = NSMutableAttributedString(string: user.userName, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: notificationMsg, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: "\(timeStamp)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    var followButtonText: String {
        return user.isFollowed ? "Following" : "Follow"
    }
    var shouldHideFollowButton: Bool {
        return notificationType != NotificationType.follow
    }
    init(notification: Notification) {
        self.notification = notification
        self.notificationType = notification.type
        self.user = notification.user
        self.profileImgURL = notification.user.profileImgURL!
    }
}
