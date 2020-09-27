//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/25.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case likes
    case replies
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    let userNameWithAtMark: String
    init(user: User){
        self.user = user
        self.userNameWithAtMark = "@" + user.userName
    }
    var followersString: NSAttributedString? {
        return attributedText(withValue: 0, text: "sample")
    }
    var followingString: NSAttributedString? {
        return attributedText(withValue: 0, text: "sample")
    }
    var actionButtonTitle: String {
        if user.isCurrentUser { return "Edit Profile" }
        if !user.isFollowed && !user.isCurrentUser { return "Follow" }
        if user.isFollowed { return "Unfollow" }
        return "Loading"
    }
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle: NSMutableAttributedString = NSMutableAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize:14)])
        
        attributedTitle.append(NSAttributedString(string: "\(text)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
}
