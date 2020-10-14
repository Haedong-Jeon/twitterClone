//
//  EditProfileViewModel.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/10/15.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullName
    case userName
    case bio
    
    var description: String {
        switch self {
        case .userName:
            return "userName"
        case .fullName:
            return "fullName"
        case .bio:
            return "bio"
        }
    }
}
