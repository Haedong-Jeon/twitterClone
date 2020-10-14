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
    func checkIfUserLikedTweet() {
        tweets.forEach { tweet in
            TweetService.shared.checkIfUserLikedTweet(tweet) { didLike in
                guard didLike == true else { return }
                if let index = self.tweets.firstIndex(where: { $0.tweetID == tweet.tweetID }) {
                    self.tweets[index].didLike = true
                }
            }
        }
    }
    func fetchTweets() {
        collectionView.refreshControl?.beginRefreshing()
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets.sorted(by: { $0.timeStamp > $1.timeStamp})
            self.checkIfUserLikedTweet()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    //MARK: - Helpers
    func configureUI() {
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControl.Event.valueChanged)
        view.backgroundColor = UIColor.white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.white
        let imageView: UIImageView = UIImageView(image: UIImage(named:"twitter_logo_blue"))
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        collectionView.refreshControl = refreshControl
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
    //MARK: - Selectors
    @objc func handleRefresh() {
        fetchTweets()
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
    func handleLikeTapped(_ cell: TweetCell) {
        guard var tweet: Tweet = cell.tweet else { return }
        TweetService.shared.updateLikesInDatabase(tweet: tweet) { (err, ref) in
            cell.tweet?.didLike.toggle()
            let likes: Int = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            tweet.didLike.toggle()
            cell.tweet?.likes = likes
        }
        guard tweet.didLike else { return }
        NotificationService.shared.uploadNotification(type: NotificationType.like, tweet: tweet)
    }
    
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
