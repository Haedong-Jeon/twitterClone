//  FeedContoller.swift
//  TwitterClone
//  Created by 전해동 on 2020/09/18.
//


import UIKit
import SDWebImage

private let reuseIdentifier: String = "TweetCell"
class FeedController: UICollectionViewController {
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
        fetchTweets()
    }
    //MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            
        }
    }
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = UIColor.white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.white
        let imageView: UIImageView = UIImageView(image: UIImage(named:"twitter_logo_blue"))
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
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
//MARK: - Collection View Control
extension FeedController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        return cell
    }
}
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
