//
//  CourseDiscoveryVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit

import Then
import SnapKit

final class CourseDiscoveryVC: UIViewController {
    // MARK: - Properties
    private lazy var navibar = CustomNavigationBar(self, type: .title).setTitle("코스 발견")
    private let searchButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icSearch, for: .normal)
        $0.tintColor = .g1
    }
    private let plusButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icPlus, for: .normal)
    }
    // MARK: - UIComponents
    private lazy var containerView = UIScrollView()
    private let adImageView = UIImageView().then {
        $0.image = UIImage(named: "adimage")
    }
    private let titleView = UIView()
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "코스 추천"
        label.font =  UIFont.h4
        label.textColor = UIColor.g1
        return label
    }()
    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 코스를 발견해나가요"
        label.font =  UIFont.b6
        label.textColor = UIColor.g1
        return label
    }()
   
    // MARK: - collectionview
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
    
    override func viewDidLoad () {
        super.viewDidLoad()
        register()
        setNavigationBar()
        layout()
        setAddTarget()
    }
}
// MARK: - Methods

extension CourseDiscoveryVC {
    private func setAddTarget() {
        self.searchButton.addTarget(self, action: #selector(presentToSearchVC), for: .touchUpInside)
        self.plusButton.addTarget(self, action: #selector(presentToDiscoveryVC), for: .touchUpInside)
    }
}
    
    // MARK: - @objc Function

    extension CourseDiscoveryVC {
        @objc private func presentToSearchVC() {
            let nextVC = SearchVC()
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: true)
        }
        @objc private func presentToDiscoveryVC() {
            let nextVC = PlusDetailVC()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }

    // MARK: - UI & Layout
extension CourseDiscoveryVC {
    private func setNavigationBar() {
        view.addSubview(navibar)
        view.addSubview(searchButton)
        
        navibar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        searchButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
        }
    }
    
    private func layout() {
        view.backgroundColor = .w1
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        view.addSubview(plusButton)
        self.view.bringSubviewToFront(plusButton)
        [adImageView, titleView, mapCollectionView].forEach {
            containerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(self.navibar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        adImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(183)
        }
        titleView.snp.makeConstraints {
            $0.top.equalTo(self.adImageView.snp.bottom).offset(11)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        titleView.addSubviews(mainLabel, subLabel)
            mainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(9)
            $0.leading.equalToSuperview().offset(16)
        }
        subLabel.snp.makeConstraints {
            $0.top.equalTo(self.mainLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
        }
        mapCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.titleView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1000)
        }
        plusButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
    }
    // MARK: - register
    
    private func register() {
        mapCollectionView.register(MapCollectionViewCell.self, forCellWithReuseIdentifier: MapCollectionViewCell.identifier)
    }
}

    // MARK: - UICollectionViewDelegateFlowLayout

    extension CourseDiscoveryVC: UICollectionViewDelegateFlowLayout {
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
    }
    // MARK: - UICollectionViewDataSource

extension CourseDiscoveryVC: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return mapList.count
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let mapCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MapCollectionViewCell.identifier, for: indexPath)
                    as? MapCollectionViewCell else { return UICollectionViewCell() }
            mapCell.dataBind(model: mapList[indexPath.item])
            
            return mapCell
        }
    }
