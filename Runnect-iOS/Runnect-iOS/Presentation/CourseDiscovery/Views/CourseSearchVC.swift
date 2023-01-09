//
//  SearchVC.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/05.
//

import UIKit

import Then
import SnapKit

final class CourseSearchVC: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .search).setTextFieldPlaceholder(placeholder: "지역과 키워드 위주로 검색해보세요").showKeyboard()
    private let dividerView = UIView().then {
        $0.backgroundColor = .g5
    }
    private lazy var mapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let alertImageView = UIImageView().then {
        $0.image = ImageLiterals.icAlert
        $0.tintColor = .g3
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "검색결과가 없습니다\n검색어를 다시 확인해주세요"
        $0.font = .b4
        $0.textColor = .g3
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private lazy var emptyDataView = UIStackView(arrangedSubviews: [alertImageView, descriptionLabel]).then {
        $0.axis = .vertical
        $0.spacing = 22
        $0.alignment = .center
    }
    
    // MARK: - Constants
    
    final let collectionViewInset = UIEdgeInsets(top: 28, left: 16, bottom: 28, right: 16)
    final let itemSpacing: CGFloat = 10
    final let lineSpacing: CGFloat = 20
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
        setNavigationBar()
        setDelegate()
        layout()
        setTabBar()
    
    }
}
// MARK: - Methods

extension CourseSearchVC {
    
    private func setDelegate() {
        self.mapCollectionView.delegate = self
        self.mapCollectionView.dataSource = self
    }
    private func register() {
        mapCollectionView.register(CourseListCVC.self,
                                   forCellWithReuseIdentifier: CourseListCVC.className)
        
    }
    private func setTabBar() {
            self.tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - UI & Layout
extension CourseSearchVC {
    private func setNavigationBar() {
        view.addSubview(naviBar)
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
    }
    private func layout() {
        view.backgroundColor = .w1
        emptyDataView.isHidden = true // 데이터가 없으면 false로 설정
        view.addSubviews(dividerView, mapCollectionView)
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(6)
        }
        mapCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.dividerView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        mapCollectionView.addSubview(emptyDataView)
        emptyDataView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CourseSearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension CourseSearchVC: UICollectionViewDelegateFlowLayout {
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.naviBar.hideKeyboard()
    }
}


