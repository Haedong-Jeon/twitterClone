//
//  UserService.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/21.
//

import Firebase

struct UserService {
    static let shared: UserService  = UserService()
    private init() {}
    
    func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid: String = Auth.auth().currentUser?.uid else { return }
        DB_REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary: [String: AnyObject] = snapshot.value as? [String: AnyObject] else { return }
            let user: User = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
}

