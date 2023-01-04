////
////  MapCollectionViewController.swift
////  Runnect-iOS
////
////  Created by YEONOO on 2023/01/02.
////
//
//import UIKit
//
//import Then
//
//// MARK: - MapCollectionViewController
//class MapCollectionViewController: UICollectionViewController {
//    // MARK: - UIComponents
//    private lazy var mapCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .clear
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.isScrollEnabled = true
//        collectionView.showsVerticalScrollIndicator = false
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        return collectionView
//    }()
//
//    // MARK: - Constants
//
//    final let inset : UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    final let lineSpacing : CGFloat = 10
//    final let interItemSpacing : CGFloat = 20
//    final let height : CGFloat = 164 //나중에 오토레이아웃으로 바꾸기 !
//
//    // MARK: - Layout Helpers
//
//    private func layout() {
//        view.addSubviews(mapCollectionView)
//        mapCollectionView.snp.makeConstraints {
//            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
//            $0.bottom.equalToSuperview()
//            $0.height.equalTo(164) //나중에 오토레이아웃으로 바꾸기
//        }
//    }
//    // MARK: - Layout Helpers
//    private func register() {
//        mapCollectionView.register(MapCollectionViewCell.self,forCellWithReuseIdentifier: MapCollectionViewCell.identifier)
//    }
//
//    // MARK: - Life Cycles
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        register()
//        layout()
//    }
//}
//
//// MARK: - UICollectionViewDelegateFlowLayout
//
//extension MapCollectionViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let screenWidth = UIScreen.main.bounds.width
//        let doubleCellWidth = screenWidth - inset.left - inset.right - interItemSpacing
//        return CGSize(width: doubleCellWidth / 2, height: 164)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return lineSpacing
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return interItemSpacing
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return inset
//    }
//}
//// MARK: - UICollectionViewDataSource
//
//extension MapCollectionViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 20 //임시
//    }
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let mapCell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: MapCollectionViewCell.identifier, for: indexPath)
//                as? MapCollectionViewCell else { return UICollectionViewCell() }
////        mapCell.dataBind(model: )
//        return mapCell
//    }
//}
