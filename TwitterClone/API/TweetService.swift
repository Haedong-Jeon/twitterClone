//
//  TweetService.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/22.
//

import Foundation
import Firebase

struct TweetService {
    static let shared: TweetService = TweetService()
    private init() {}
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference)-> Void) {
        guard let uid: String = Auth.auth().currentUser?.uid else { return }
        let values: [String: Any] = ["uid": uid, "timeStamp": Int(NSDate().timeIntervalSince1970), "likes": 0, "retweets": 0, "caption": caption] as [String : Any]
        DB_REF_TWEETS.updateChildValues(values, withCompletionBlock: completion)
    }
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = [Tweet]()
        DB_REF_TWEETS.observe(DataEventType.childAdded) { snapShot in
            guard let dictionary: [String: Any] = snapShot.value as? [String: Any] else { return }
            let tweetId: String = snapShot.key
            let tweet = Tweet(tweetId: tweetId, dictionary: dictionary)
            tweets.append(tweet)
            
            completion(tweets)
        }
    }
}
