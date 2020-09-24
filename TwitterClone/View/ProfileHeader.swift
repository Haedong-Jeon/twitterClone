//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/24.
//

import UIKit

class ProfileHeader: UICollectionReusableView {
    //MARK: - Properties
    //MARK: - LifeCycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
}
