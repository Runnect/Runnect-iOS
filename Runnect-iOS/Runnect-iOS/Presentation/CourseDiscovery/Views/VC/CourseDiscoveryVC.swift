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
  
    // MARK: - UIComponents
    
    private lazy var navibar = CustomNavigationBar(self, type: .title).setTitle("코스 발견")
    private let searchButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icSearch, for: .normal)
        $0.tintColor = .g1
    }
    private let plusButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icPlus, for: .normal)
    }
   
    // MARK: - collectionview
    
    private lazy var mapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad () {
        super.viewDidLoad()
        register()
        setNavigationBar()
        setDelegate()
        layout()
        setAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideTabBar(wantsToHide: false)
    }
}

// MARK: - Methods

extension CourseDiscoveryVC {
    
    private func setDelegate() {
        mapCollectionView.delegate = self
        mapCollectionView.dataSource = self
    }
    
    private func register() {
        self.mapCollectionView.register(AdImageCollectionViewCell.self, forCellWithReuseIdentifier: AdImageCollectionViewCell.className)
        self.mapCollectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.className)
        self.mapCollectionView.register(CourseListCVC.self, forCellWithReuseIdentifier: CourseListCVC.className)
    }
    
    private func setAddTarget() {
        
        self.searchButton.addTarget(self, action: #selector(pushToSearchVC), for: .touchUpInside)
        self.plusButton.addTarget(self, action: #selector(pushToDiscoveryVC), for: .touchUpInside)
        
    }
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
            make.centerY.equalTo(navibar)
        }
    }
    
    private func layout() {
        view.backgroundColor = .w1
        mapCollectionView.backgroundColor = .w1
        view.addSubviews(plusButton, mapCollectionView)
        view.bringSubviewToFront(plusButton)

        mapCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.navibar.snp.bottom)
            $0.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        plusButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CourseDiscoveryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
        case 2:
            return 15
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdImageCollectionViewCell.className, for: indexPath) as? AdImageCollectionViewCell else { return UICollectionViewCell() }
            return cell
        } else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.className, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseListCVC.className, for: indexPath) as? CourseListCVC else { return UICollectionViewCell() }
            cell.setCellType(type: .all)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CourseDiscoveryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        _ = UICollectionViewCell()
        
        let screenWidth = UIScreen.main.bounds.width
        
        switch indexPath.section {
        case 0:
            return CGSize(width: screenWidth, height: screenWidth * (183/390))
        case 1:
            return CGSize(width: screenWidth, height: 80)
        case 2:
            let cellWidth = (screenWidth - 42) / 2
            let cellHeight = CourseListCVCType.getCellHeight(type: .all, cellWidth: cellWidth)
            return CGSize(width: cellWidth, height: cellHeight)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 2 {
            return 20
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 2 {
            return 10
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 2 {
            return UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let courseDetailVC = CourseDetailVC()
            self.navigationController?.pushViewController(courseDetailVC, animated: true)
        }
    }
}
