//
//  User.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/21.
//

import Foundation
import Firebase

struct User {
    let fullName: String
    let email: String
    let userName: String
    let uid: String
    var profileImgURL: URL?
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == self.uid }
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        self.fullName = dictionary["fullName"] as? String ?? "User model Error"
        self.userName = dictionary["userName"] as? String ?? "User model Error"
        self.email = dictionary["email"] as? String ?? "User model Error"
        
        if let profileImgURLString: String = dictionary["profileImgURL"] as? String {
            self.profileImgURL = URL(string: profileImgURLString)!
        }
    }
}
