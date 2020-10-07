//
//  NotificationService.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/10/07.
//

import Firebase

struct NotificationService {
    private init() {}
    static let shared: NotificationService = NotificationService()
    func uploadNotification(type: NotificationType, tweet: Tweet? = nil, user: User? = nil) {
        guard let uid: String = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["timeStamp": Int(NSDate().timeIntervalSince1970), "uid": uid, "type": type.rawValue]
        
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetID
            DB_REF_NOTIFICATIONS.child(tweet.user!.uid).childByAutoId().updateChildValues(values)
        } else if let user = user {
            DB_REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
        }
    }
    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        var notifications:[Notification] = [Notification]()
        guard let uid: String = Auth.auth().currentUser?.uid else { return }
        
        DB_REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapShot in
            guard let dictionary: [String: AnyObject] = snapShot.value as? [String: AnyObject] else { return }
            guard let uid: String = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let notification = Notification(user: user, dictionary: dictionary)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }
}
