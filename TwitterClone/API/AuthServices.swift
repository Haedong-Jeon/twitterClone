//
//  AuthServices.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct AuthCredentials {
    let email: String
    let password: String
    let fullName: String
    let userName: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared: AuthService = AuthService()
    func registerUser(credential: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let imageData: Data = credential.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let profileImgfileName: String = NSUUID().uuidString
        let userProfileImgRef = STORAGE_REF_PROFILE_IMGS.child(profileImgfileName)
        
        Auth.auth().createUser(withEmail: credential.email, password: credential.password) { (result, error) in
            if let error = error {
                print("DEBUG: error in creat user - \(error.localizedDescription)")
                return
            }
            userProfileImgRef.putData(imageData, metadata: nil) { (meta, error) in
                if let error = error {
                    print("DEBUG: error in put img Data - \(error.localizedDescription)")
                }
                userProfileImgRef.downloadURL { (url, error) in
                    guard let profileImgUrl: String = url?.absoluteString else { return }
                    if let error = error {
                        print("DEBUG: error in get image url - \(error.localizedDescription)")
                        return
                    }
                    guard let uid: String = result?.user.uid else { return }
                    let values: [String: Any] = ["email": credential.email, "userName": credential.userName, "fullName": credential.fullName, "profileImgURL": profileImgUrl]
                    DB_REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                        completion(err, ref)
                    }
                }
            }
        }
    }
}
