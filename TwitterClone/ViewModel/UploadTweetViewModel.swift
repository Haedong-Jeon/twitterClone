//
//  UploadTweetViewModel.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/29.
//

import UIKit

enum UploadTweetConfiguration {
    case tweet
    case reply(to: Tweet)
}

struct UploadTweetViewModel {
    let actionButtonTitle: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    var replyText: String?
    
    init(config: UploadTweetConfiguration) {
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "Whats happening?"
            shouldShowReplyLabel = false
            
        case .reply(to: let tweet):
            actionButtonTitle = "Reply"
            placeholderText = "tweet your reply"
            shouldShowReplyLabel = true
            replyText = "Replying at @\(tweet.user?.userName ?? "error")" 
        }
    }
}
