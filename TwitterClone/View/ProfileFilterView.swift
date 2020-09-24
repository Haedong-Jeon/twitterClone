//
//  ProfileFilterView.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/24.
//

import UIKit

private let reuseIdentifier: String = "profileFilterCell"
protocol ProfileFilterViewDelegate: class {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath)
}

class ProfileFilterView: UIView {
    //MARK: - Properties
    weak var delegate: ProfileFilterViewDelegate?
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        let initialSelection: IndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: initialSelection, animated: true, scrollPosition: UICollectionView.ScrollPosition.left)
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOptions.allCases.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ProfileFilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProfileFilterCell else {
            return UICollectionViewCell()
        }
        let option: ProfileFilterOptions = ProfileFilterOptions(rawValue: indexPath.row)!
        cell.option = option
        return cell
    }
}
extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellCount: CGFloat = CGFloat(ProfileFilterOptions.allCases.count)
        return CGSize(width: frame.width / cellCount, height: frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
//MARK: - UICollectionViewDelegate
extension ProfileFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filterView(self, didSelect: indexPath)
    }
}
