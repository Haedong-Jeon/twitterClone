//
//  Tweets.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/23.
//

import Firebase

struct Tweet {
    let caption: String
    let tweetID: String
    let uid: String
    var likes: Int
    var timeStamp: Date!
    var user: User?
    var didLike: Bool = false
    let retweetCount: Int
    
    init(tweetID: String, dictionary: [String: Any]) {
        self.tweetID = tweetID
        self.caption = dictionary["caption"] as? String ?? "Error in caption"
        self.uid = dictionary["uid"] as? String ?? "Error in uid"
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweets"] as? Int ?? 0
        if let timeStamp = dictionary["timeStamp"] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timeStamp)
        }
    }
}
