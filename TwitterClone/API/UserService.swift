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
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        DB_REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary: [String: AnyObject] = snapshot.value as? [String: AnyObject] else { return }
            let user: User = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
}

