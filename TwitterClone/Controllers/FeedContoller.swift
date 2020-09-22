//  FeedContoller.swift
//  TwitterClone
//  Created by 전해동 on 2020/09/18.
//


import UIKit
import SDWebImage

class FeedController: UIViewController {
    //MARK: - Properties
    var user: User? {
        didSet {
            configureLeftBarButton()
        }
    }
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
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
    }
    func configureLeftBarButton() {
        guard let user: User = user else { return }

        let profileImgView: UIImageView = UIImageView()
        profileImgView.setDimensions(width: 32, height: 32)
        profileImgView.layer.cornerRadius = 32 / 2
        profileImgView.layer.masksToBounds = true
        profileImgView.sd_setImage(with: user.profileImgURL , completed: nil)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImgView)
    }
}
