//
//  MapCollectionViewController.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/05.
//

import UIKit

private let reuseIdentifier = "MapCollectionViewCell"

class MapCollectionViewController: UICollectionViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .w1
        collectionView?.register(MapCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

// MARK: - Constants

let inset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
let lineSpacing: CGFloat = 10
let interItemSpacing: CGFloat = 20
let height: CGFloat = 164

    // MARK: - UICollectionViewDelegateFlowLayout

extension MapCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let doubleCellWidth = screenWidth - inset.left - inset.right - interItemSpacing
        return CGSize(width: doubleCellWidth / 2, height: 164)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return inset
    }
    // MARK: - UICollectionViewDataSourc
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let mapCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MapCollectionViewCell.identifier, for: indexPath)
                as? MapCollectionViewCell else { return UICollectionViewCell() }
        
        return mapCell
    }
}
