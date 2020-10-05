//
//  TweetController.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/28.
//

import UIKit

private let headerReuseIdentifier: String = "HeaderReuseIdentifier"
private let cellReuseIdentifier: String = "TweetCell"

class TweetController: UICollectionViewController {
    //MARK: - Properties
    private let tweet: Tweet
    private var actionSheetLauncher: ActionSheetLauncher?
    private var replies: [Tweet] = [Tweet](){
        didSet {
            collectionView.reloadData()
        }
    }
    //MARK: - LifeCycles
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchReplies()
    }
    //MARK: - Helpers
    func configureCollectionView() {
        collectionView.backgroundColor = UIColor.white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier )
    }
    func showActionSheet(forUser user: User) {
        self.actionSheetLauncher = ActionSheetLauncher(user: user)
        self.actionSheetLauncher!.delegate = self
        self.actionSheetLauncher!.show()
    }
    //MARK: - Selectors
    //MARK: - API
    func fetchReplies() {
        TweetService.shared.fetchReplies(forTweet: tweet) { replies in
            self.replies = replies
        }
    }
}
//MARK: - UICollectionView DataSource / Delegate
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: TweetCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? TweetCell else {
            return UICollectionViewCell()
        }
        cell.tweet = replies[indexPath.row]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header: TweetHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as? TweetHeader else {
            return UICollectionReusableView()
        }
        header.tweet = self.tweet
        header.delegate = self
        return header
    }
}
//MARK: - UICollectionView Flow Layout
extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel: TweetViewModel = TweetViewModel(tweet: self.tweet)
        let captionHeight: CGFloat = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: collectionView.frame.width, height: captionHeight + 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 250)
    }
}
//MARK: - Tweet Header Delegate
extension TweetController: TweetHeaderDelegate {
    func showActionSheet() {
        if tweet.user!.isCurrentUser {
            showActionSheet(forUser: tweet.user!)
        } else {
            UserService.shared.checkIfUserIsFollowed(uid: tweet.user!.uid) { [self] isFollowed in
                var user = self.tweet.user!
                user.isFollowed = isFollowed
                showActionSheet(forUser: tweet.user!)
            }
        }
    }
}
extension TweetController: ActionSheetLauncherDelegate {
    func didSelect(options: ActionSheetOptions) {
    }
}
