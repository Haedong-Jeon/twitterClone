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
        let viewModel: TweetViewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height: CGFloat = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: collectionView.frame.width, height: height + 72)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tweetController: TweetController = TweetController(tweet: tweets[indexPath.row])
        navigationController?.pushViewController(tweetController, animated: true)
    }
}
extension FeedController: TweetCellDelegateProtocol {
    func handleProfileImgTapped(_ cell: TweetCell) {
        guard let user: User = cell.tweet?.user else { return }
        let controller: ProfileController = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet: Tweet = cell.tweet else { return }
        let controller: UploadTweetsController = UploadTweetsController(user: tweet.user!, config: .reply(to: tweet))
        
        let navigation: UINavigationController = UINavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(navigation, animated: true, completion: nil)
    }
}
