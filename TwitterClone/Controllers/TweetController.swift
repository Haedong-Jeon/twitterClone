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
    }
    //MARK: - Helpers
    func configureCollectionView() {
        collectionView.backgroundColor = UIColor.white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier )
    }
    //MARK: - Selectors
    //MARK: - API
}

//MARK: - UICollectionView DataSource / Delegate
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: TweetCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? TweetCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header: TweetHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as? TweetHeader else {
            return UICollectionReusableView()
        }
        header.tweet = self.tweet
        return header
    }
}
//MARK: - UICollectionView Flow Layout
extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel: TweetViewModel = TweetViewModel(tweet: self.tweet)
        let captionHeight: CGFloat = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: collectionView.frame.width, height: captionHeight + 260)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 250)
    }
}
