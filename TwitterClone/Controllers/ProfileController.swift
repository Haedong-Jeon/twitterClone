//
//  ProfileController.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/24.
//

import UIKit
private let reuseIdentifier: String = "TweetCell"
private let reuseIdentifierForHeader: String = "TweetHeader"


class ProfileController: UICollectionViewController {
    //MARK: - Properties
    private var user: User
    private var selectedFilter: ProfileFilterOptions = ProfileFilterOptions.tweets {
        didSet {
            collectionView.reloadData()
        }
    }
    private var tweets: [Tweet] = [Tweet]()
    private var likedTweets: [Tweet] = [Tweet]()
    private var replyTweets: [Tweet] = [Tweet]()
    
    private var currentDataSource: [Tweet] {
        switch selectedFilter {
        case .tweets:
            return tweets
        case .likes:
            return likedTweets
        case .replies:
            return replyTweets
        }
    }

    //MARK: - LifeCycles
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweets()
        fetchLikedTweets()
        fetchUserStats()
        fetchReplies()
        checkIfUserFollowed()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = UIBarStyle.black
    }
    //MARK: - Helpers
    func configureCollectionView() {
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifierForHeader)
        
        guard let tapHeight: CGFloat = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tapHeight
    }
    //MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
            self.collectionView.reloadData()
        }
    }
    func checkIfUserFollowed() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    func fetchLikedTweets() {
        TweetService.shared.fetchLikes(forUser: user) { tweets in
            self.likedTweets = tweets
        }
    }
    func fetchReplies() {
        TweetService.shared.fetchReplies(forUser: user) { tweets in
            self.replyTweets = tweets
        }
    }
}
//MARK: - UICollectionView Delegate
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header: ProfileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifierForHeader, for: indexPath) as? ProfileHeader else {
            return UICollectionReusableView()
        }
        header.user = user
        header.delegate = self
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tweetController: TweetController = TweetController(tweet: currentDataSource[indexPath.row])
        navigationController?.pushViewController(tweetController, animated: true)
    }
}
//MARK: - UICollectionView Control
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentDataSource.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: TweetCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TweetCell else {
            return UICollectionViewCell()
        }
        cell.tweet = self.currentDataSource[indexPath.row]
        return cell
    }
}
//MARK: - UICollectionView layout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel: TweetViewModel = TweetViewModel(tweet: tweets[indexPath.row])
        var height: CGFloat = viewModel.size(forWidth: view.frame.width).height
        
        if currentDataSource[indexPath.row].isReply {
            height += 20
        }
        return CGSize(width: collectionView.frame.width, height: height + 72)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
}
extension ProfileController: ProfileHeaderDelegate {
    func didSelect(filter: ProfileFilterOptions) {
        self.selectedFilter = filter
    }
    
    func handleBackButton() {
        navigationController?.popViewController(animated: true)
    }
    func handleEditProfileFollow(_ header: ProfileHeader) {
        if self.user.isCurrentUser {
            let controller: EditProfileController = EditProfileController(user: user)
            let nav: UINavigationController = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            present(nav, animated: true, completion: nil)
            return
        }
        
        if self.user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { (error, ref) in
                self.user.isFollowed.toggle()
                self.collectionView.reloadData()
                
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { (error, ref) in
                self.user.isFollowed.toggle()
                self.collectionView.reloadData()
                
                NotificationService.shared.uploadNotification(type: NotificationType.follow, user: self.user)
            }
        }
    }
}
