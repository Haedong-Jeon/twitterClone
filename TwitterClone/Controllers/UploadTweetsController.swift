//
//  UploadTweetsController.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/22.
//

import UIKit

class UploadTweetsController: UIViewController {
    //MARK: - properties
    private lazy var actionButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = UIColor.twitterBlue
        button.setTitle("tweet", for: UIControl.State.normal)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        
        button.addTarget(self, action: #selector(handleUploadTweet), for: UIControl.Event.touchUpInside)
        return button
    }()
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - Selector
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    @objc func handleUploadTweet() {
        
    }
    //MARK: - API
    //MARK: - Helper
    func configureUI() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
        
    }
}

