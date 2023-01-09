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
    
    let adImageCellId = "AdImageCollectionViewCell"
    let titleCellId = "TitleCollectionViewCell"
    let collectionViewId = "CollectionViewCell"
  
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
}
// MARK: - Methods

extension CourseDiscoveryVC {
    
    private func setDelegate() {
        mapCollectionView.delegate = self
        mapCollectionView.dataSource = self
    }
    private func register() {
        self.mapCollectionView.register(AdImageCollectionViewCell.self, forCellWithReuseIdentifier: adImageCellId)
        self.mapCollectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: titleCellId)
        self.mapCollectionView.register(MapCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewId)
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
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
        }
    }
    
    private func layout() {
        view.backgroundColor = .w1
        mapCollectionView.backgroundColor = .w1
        self.tabBarController?.tabBar.isHidden = false
        view.addSubviews(plusButton, mapCollectionView)
        view.bringSubviewToFront(plusButton)

        mapCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.navibar.snp.bottom).offset(10)
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
               
               if indexPath.section == 0 {
                   cell = collectionView.dequeueReusableCell(withReuseIdentifier: adImageCellId, for: indexPath) as! AdImageCollectionViewCell
               } else if indexPath.section == 1 {
                   cell = collectionView.dequeueReusableCell(withReuseIdentifier: titleCellId, for: indexPath) as! TitleCollectionViewCell
               } else {
                   cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewId, for: indexPath) as! MapCollectionViewCell
               }
               
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CourseDiscoveryVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        _ = UICollectionViewCell()
           return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
       }

}
