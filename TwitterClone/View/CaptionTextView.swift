//
//  CaptionTextView.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/22.
//

import UIKit

class CaptionTextView: UITextView {
    //MARK: - Properties
    let placeHolderLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkGray
        label.text = "What's happeing?"
        return label
    }()
    //MARK: - LifeCycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        backgroundColor = UIColor.white
        font = UIFont.systemFont(ofSize: 16)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - selector
    @objc func handleTextInputChange() {
        placeHolderLabel.isHidden = !text.isEmpty
    }
}
