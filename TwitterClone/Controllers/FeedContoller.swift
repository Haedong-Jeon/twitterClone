//  FeedContoller.swift
//  TwitterClone
//  Created by 전해동 on 2020/09/18.
//


import UIKit

class FeedController: UIViewController {
    //MARK: - Properties
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = UIColor.white
        let imageView: UIImageView = UIImageView(image: UIImage(named:"twitter_logo_blue"))
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFit
        navigationItem.titleView = imageView
    }
}
