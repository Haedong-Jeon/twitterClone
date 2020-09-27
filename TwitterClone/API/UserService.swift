//
//  UserService.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/21.
//

import Firebase
typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    static let shared: UserService  = UserService()
    private init() {}
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        DB_REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary: [String: AnyObject] = snapshot.value as? [String: AnyObject] else { return }
            let user: User = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users: [User] = [User]()
        DB_REF_USERS.observe(.childAdded) { snapShot in
            let uid: String = snapShot.key
            guard let dictionary: [String: AnyObject] = snapShot.value as? [String: AnyObject] else { return }
            let user: User = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid: String = Auth.auth().currentUser?.uid else { return }
        DB_REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { (error, ref) in
            DB_REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid: String = Auth.auth().currentUser?.uid else { return }
        DB_REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { (error, ref) in
            DB_REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid: String = Auth.auth().currentUser?.uid else { return }
        DB_REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapShot in
            completion(snapShot.exists())
        }
    }
    func fetchUserStats(uid: String, completion: @escaping(UserRelationStats) -> Void) {
        DB_REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapShot in
            let followersCount: Int = snapShot.children.allObjects.count
            DB_REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapShot in
                let followingCount: Int = snapShot.children.allObjects.count
                let stats: UserRelationStats = UserRelationStats(followers: followersCount, following: followingCount)
                completion(stats)
            }
        }
    }
}

