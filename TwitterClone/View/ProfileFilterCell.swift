//
//  ProfileFilterCell.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/24.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    //MARK: - properties
    private let titleLabel: UILabel = {
        var label: UILabel = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "TEST"
        return label
    }()
    override var isSelected: Bool {
        didSet{
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? UIColor.twitterBlue : UIColor.lightGray
        }
    }
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
}
