//
//  PlusDetailViewController.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/05.
//

import UIKit
import Then

class MyCourseSelectVC: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton).setTitle("불러오기")
    private let selectButton = CustomButton(title: "선택하기").setColor(bgColor: .g3, disableColor: .g3, textColor: .w1)
    
    // MARK: - collectionview
    private lazy var containerView = UIScrollView()
    private lazy var mapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    // MARK: - Constants
    
    var mapList: [MapModel] = [
    MapModel(mapImage: "", title: "제목제목제목제목", location: "00동00구"),
    MapModel(mapImage: "", title: "제목제목제목제목", location: "00동00구"),
    MapModel(mapImage: "", title: "제목제목제목제목", location: "00동00구"),
    MapModel(mapImage: "", title: "제목제목제목제목", location: "00동00구"),
    MapModel(mapImage: "", title: "제목제목제목제목", location: "00동00구"),
    MapModel(mapImage: "", title: "제목제목제목제목", location: "00동00구"),
    MapModel(mapImage: "", title: "제목제목제목제목", location: "00동00구"),
    MapModel(mapImage: "", title: "제목제목제목제목", location: "00동00구")
    ]
    final let inset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
    final let lineSpacing: CGFloat = 10
    final let interItemSpacing: CGFloat = 20
    final let height: CGFloat = 164
    
    // MARK: - Life Cycle

    override func viewDidLoad () {
        super.viewDidLoad()
        register()
        setNavigationBar()
        setUI()
        setLayout()
        setAddTarget()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
// MARK: - Methods

extension MyCourseSelectVC {
    private func setAddTarget() {
        self.selectButton.addTarget(self, action: #selector(presentToUploadVC), for: .touchUpInside)
    }
}
    // MARK: - @objc Function

    extension MyCourseSelectVC {
        @objc private func presentToUploadVC() {
            let nextVC = UploadVC()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    // MARK: - naviVar Layout

extension MyCourseSelectVC {
    private func setNavigationBar() {
        view.addSubview(navibar)
        navibar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
    }
}
    // MARK: - setUI
    private func setUI() {
        view.backgroundColor = .w1
        containerView.backgroundColor = .clear
        self.tabBarController?.tabBar.isHidden = true
    }
    // MARK: - Layout Helpers
    private func setLayout() {
        view.addSubview(containerView)
        view.addSubview(selectButton)
        self.view.bringSubviewToFront(selectButton)
        containerView.addSubview(mapCollectionView)

        containerView.snp.makeConstraints {
            $0.top.equalTo(self.navibar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        mapCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.height.equalTo(1000)
        }
        
        selectButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(34)
        }
    }
    private func register() {
        mapCollectionView.register(MapCollectionViewCell.self, forCellWithReuseIdentifier: MapCollectionViewCell.identifier)
    }
}
// MARK: - UICollectionViewDelegateFlowLayout

extension MyCourseSelectVC: UICollectionViewDelegateFlowLayout {
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MapCollectionViewCell
        if cell.clickCount == 1 {
            cell.clickCount = 0
        } else {
            cell.clickCount += 1
        }
    }
}
// MARK: - UICollectionViewDataSource

extension MyCourseSelectVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mapList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let mapCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MapCollectionViewCell.identifier, for: indexPath)
                as? MapCollectionViewCell else { return UICollectionViewCell() }
        mapCell.dataBind(model: mapList[indexPath.item])
        mapCell.heartButton.isHidden = true

        return mapCell
    }
}
