//
//  ActionSheetCell.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/10/05.
//

import UIKit

class ActionSheetCell: UITableViewCell {
    //MARK: - properties
    var options: ActionSheetOptions? {
        didSet {
            configure()
        }
    }
    private let optionImgView: UIImageView = {
        var imgView: UIImageView = UIImageView()
        imgView.contentMode = UIImageView.ContentMode.scaleAspectFit
        imgView.clipsToBounds = true
        imgView.image = #imageLiteral(resourceName: "twitter_logo_blue")
        return imgView
    }()
    private let titleLabel: UILabel = {
        var label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "TEST OBJECT"
        return label
    }()
    //MARK: - lifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.addSubview(optionImgView)
        optionImgView.centerY(inView: self)
        optionImgView.anchor(left: leftAnchor, paddingLeft: 8)
        optionImgView.setDimensions(width: 36, height: 36)
        
        self.addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: optionImgView.rightAnchor, paddingLeft: 12)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Helpers
    func configure() {
        titleLabel.text = options?.description
    }
}
