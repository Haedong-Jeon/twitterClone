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
        var values: [String: Any] = ["uid": uid, "timeStamp": Int(NSDate().timeIntervalSince1970), "likes": 0, "retweets": 0, "caption": caption] as [String : Any]
        
        switch type {
        case .tweet:
            DB_REF_TWEETS.childByAutoId().updateChildValues(values) { (error, ref) in
                guard let tweetID: String = ref.key else { return }
                DB_REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
        case .reply(to: let tweet):
            values["replyTo"] = tweet.user?.userName
            DB_REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(values) { (error, ref) in
                guard let replyKey: String = ref.key else { return }
                DB_REF_USER_REPLIES.child(uid).updateChildValues([tweet.tweetID: replyKey], withCompletionBlock: completion)
            }
        }
    }
    func fetchTweet(withTweetID tweetID: String, completion: @escaping(Tweet) -> Void) {
        DB_REF_TWEETS.observe(DataEventType.childAdded) { snapShot in
            if snapShot.key != tweetID {
                return
            }
            guard let dictionary: [String: Any] = snapShot.value as? [String: Any] else { return }
            guard let uid: String = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                var tweet: Tweet = Tweet(tweetID: tweetID, dictionary: dictionary)
                tweet.user = user
                completion(tweet)
            }
        }
    }
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = [Tweet]()
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        DB_REF_USER_FOLLOWING.child(currentUID).observe(.childAdded) { snapShot in
            let followingUID: String = snapShot.key
            
            DB_REF_USER_TWEETS.child(followingUID).observe(.childAdded) { snapShot in
                let tweetID: String = snapShot.key
                self.fetchTweet(withTweetID: tweetID) { tweet in
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
        DB_REF_USER_TWEETS.child(currentUID).observe(.childAdded) { snapShot in
            let tweetID: String = snapShot.key
            self.fetchTweet(withTweetID: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = [Tweet]()
        DB_REF_USER_TWEETS.child(user.uid).observe(DataEventType.childAdded) { snapShot in
            let tweetID: String = snapShot.key
            self.fetchTweet(withTweetID: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    func fetchReplies(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var replies: [Tweet] = [Tweet]()
        
        DB_REF_USER_REPLIES.child(user.uid).observe(.childAdded) { snapShot in
            let tweetKey: String = snapShot.key
            guard let replyKey = snapShot.value as? String else { return }
            
            DB_REF_TWEET_REPLIES.child(tweetKey).child(replyKey).observeSingleEvent(of: .value) { snapShot in
                guard let dictionary: [String: Any] = snapShot.value as? [String: Any] else { return }
                guard let uid: String = dictionary["uid"] as? String else { return }
                
                let replyID: String = snapShot.key
                
                UserService.shared.fetchUser(uid: uid) { user in
                    var reply: Tweet = Tweet(tweetID: replyID, dictionary: dictionary)
                    reply.user = user
                    replies.append(reply)
                    completion(replies)
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
    func fetchLikes(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = [Tweet]()
        DB_REF_USER_LIKES.child(user.uid).observe(.childAdded) { snapShot in
            let tweetID: String = snapShot.key
            self.fetchTweet(withTweetID: tweetID) { likedTweet in
                var tweet: Tweet = likedTweet
                tweet.didLike = true
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
        DB_REF_USER_LIKES.child(uid).child(tweet.tweetID).observeSingleEvent(of: .value) { snapShot in
            print(snapShot.exists())
            completion(snapShot.exists())
        }
    }
}
