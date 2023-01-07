//
//  CourseDiscoveryVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit

import Then
import SnapKit
import Combine

final class CourseDiscoveryVC: UIViewController {
    // MARK: - Properties

    var courseDrawButtonTapped = PassthroughSubject<Void, Never>()
    var cellDidTapped = PassthroughSubject<Int, Never>()
    private let cancelBag = CancelBag()
    
    // MARK: - UIComponents
    private lazy var navibar = CustomNavigationBar(self, type: .title).setTitle("코스 발견")
    private let searchButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icSearch, for: .normal)
        $0.tintColor = .g1
    }
    private let plusButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icPlus, for: .normal)
    }

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
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Constants
    
    final let collectionViewInset = UIEdgeInsets(top: 28, left: 16, bottom: 28, right: 16)
    final let itemSpacing: CGFloat = 10
    final let lineSpacing: CGFloat = 20
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad () {
        super.viewDidLoad()
        register()
        setNavigationBar()
        setDelegate()
        layout()
        setAddTarget()
//      cellAddTarget()
        self.tabBarController?.tabBar.isHidden = false
    }
}
// MARK: - Methods

extension CourseDiscoveryVC {
    
    private func setDelegate() {
        mapCollectionView.delegate = self
        mapCollectionView.dataSource = self
    }
    private func register() {
        mapCollectionView.register(CourseListCVC.self,
                                          forCellWithReuseIdentifier: CourseListCVC.className)
    }
    private func setAddTarget() {
        
        self.searchButton.addTarget(self, action: #selector(pushToSearchVC), for: .touchUpInside)
        self.plusButton.addTarget(self, action: #selector(pushToDiscoveryVC), for: .touchUpInside)
    }
    
//    private func cellAddTarget() {
//        self.courseImageView.addTarget(self, action: #selector(CourseDetailVC), for: .touchUpInside)
//    }
}
    
    // MARK: - @objc Function

    extension CourseDiscoveryVC {
        @objc private func pushToSearchVC() {
            let nextVC = CourseSearchVC()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        @objc private func pushToDiscoveryVC() {
            let nextVC = MyCourseSelectVC()
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
        self.tabBarController?.tabBar.isHidden = false
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
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CourseDiscoveryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseListCVC.className,
                                                            for: indexPath)
                as? CourseListCVC else { return UICollectionViewCell() }
        cell.setCellType(type: .all)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CourseDiscoveryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (UIScreen.main.bounds.width - (self.itemSpacing + 2*self.collectionViewInset.left)) / 2
        let cellHeight = CourseListCVCType.getCellHeight(type: .all, cellWidth: cellWidth)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.collectionViewInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.lineSpacing
    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.cellDidTapped.send(indexPath.item)
//    }
}
