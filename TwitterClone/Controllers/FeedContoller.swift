//  FeedContoller.swift
//  TwitterClone
//  Created by 전해동 on 2020/09/18.
//


import UIKit
import SDWebImage

private let reuseIdentifier: String = "TweetCell"

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
    var user: User? {
        didSet {
            configureLeftBarButton()
        }
    }
    var tweets: [Tweet] = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = UIBarStyle.default
        navigationController?.navigationBar.isHidden = false
    }
    //MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets
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
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tweets.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: TweetCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TweetCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}
extension FeedController: TweetCellDelegateProtocol {
    func handlProfileImgTapped(_ cell: TweetCell) {
        guard let user: User = cell.tweet?.user else { return }
        let controller: ProfileController = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
