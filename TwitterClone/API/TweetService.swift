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
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion: @escaping(DatabaseCompletion)) {
        guard let uid: String = Auth.auth().currentUser?.uid else { return }
        let values: [String: Any] = ["uid": uid, "timeStamp": Int(NSDate().timeIntervalSince1970), "likes": 0, "retweets": 0, "caption": caption] as [String : Any]
        
        switch type {
        case .tweet:
            DB_REF_TWEETS.childByAutoId().updateChildValues(values) { (error, ref) in
                guard let tweetID: String = ref.key else { return }
                DB_REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
        case .reply(to: let tweet):
            DB_REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        }
    }
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = [Tweet]()
        DB_REF_TWEETS.observe(DataEventType.childAdded) { snapShot in
            guard let dictionary: [String: Any] = snapShot.value as? [String: Any] else { return }
            guard let uid: String = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweetID: String = snapShot.key
                var tweet: Tweet = Tweet(tweetID: tweetID, dictionary: dictionary)
                tweet.user = user
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = [Tweet]()
        DB_REF_USER_TWEETS.child(user.uid).observe(DataEventType.childAdded) { snapShot in
            let tweetID: String = snapShot.key
            DB_REF_TWEETS.child(tweetID).observeSingleEvent(of: DataEventType.value) { snapShot in
                guard let dictionary: [String: Any] = snapShot.value as? [String: Any] else { return }
                guard let uid: String = dictionary["uid"] as? String else { return }
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweetID: String = snapShot.key
                    var tweet: Tweet = Tweet(tweetID: tweetID, dictionary: dictionary)
                    tweet.user = user
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = [Tweet]()
        DB_REF_TWEET_REPLIES.child(tweet.tweetID).observe(.childAdded) { snapShot in
            guard let dictionary: [String: Any] = snapShot.value as? [String: Any] else { return }
            guard let uid: String = dictionary["uid"] as? String else { return }
            let tweetID: String = snapShot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                var tweet: Tweet = Tweet(tweetID: tweetID, dictionary: dictionary)
                tweet.user = user
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    func updateLikesInDatabase(tweet: Tweet, completion: @escaping(DatabaseCompletion)) {
        guard let uid: String = Auth.auth().currentUser?.uid else { return }
        let likes: Int = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        DB_REF_TWEETS.child(tweet.tweetID).child("likes").setValue(likes)
        
        if tweet.didLike {
            DB_REF_USER_LIKES.child(uid).child(tweet.tweetID).removeValue { (err, ref) in
                DB_REF_TWEET_LIKES.child(tweet.tweetID).removeValue(completionBlock: completion)
            }
        } else {
            DB_REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetID: 1]) { (err, ref) in
                DB_REF_TWEET_LIKES.child(tweet.tweetID).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid: String = Auth.auth().currentUser?.uid else { return }
        DB_REF_USER_LIKES.child(uid).child(tweet.uid).observeSingleEvent(of: .value) { snapShot in
            completion(snapShot.exists())
        }
    }
}
