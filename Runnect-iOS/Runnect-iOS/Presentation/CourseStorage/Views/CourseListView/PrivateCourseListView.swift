//
//  PrivateCourseListView.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/06.
//

import UIKit
import Combine

final class PrivateCourseListView: UIView {
    
    // MARK: - Properties
    
    var courseDrawButtonTapped = PassthroughSubject<Void, Never>()
    
    final let collectionViewInset = UIEdgeInsets(top: 28, left: 16, bottom: 28, right: 16)
    final let itemSpacing: CGFloat = 10
    final let lineSpacing: CGFloat = 20
    
    // MARK: - UI Components
    
    private let collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    private lazy var courseListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.backgroundColor = .clear
    }
    
    private let emptyView = ListEmptyView(description: "아직 내가 그린코스가 없어요\n직접 코스를 그려주세요",
                                          buttonTitle: "코스 그리기")
    
    // MARK: - initialization
    
    init() {
        super.init(frame: .zero)
        self.setUI()
        self.setLayout()
        self.setDelegate()
        self.register()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension PrivateCourseListView {
    private func setDelegate() {
        courseListCollectionView.delegate = self
        courseListCollectionView.dataSource = self
        
        emptyView.delegate = self
    }
    
    private func register() {
        courseListCollectionView.register(CourseListCVC.self,
                                          forCellWithReuseIdentifier: CourseListCVC.className)
    }
}

// MARK: - UI & Layout

extension PrivateCourseListView {
    private func setUI() {
        self.backgroundColor = .w1
    }
    
    private func setLayout() {
        self.addSubviews(courseListCollectionView)
        courseListCollectionView.addSubviews(emptyView)

        courseListCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(80)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PrivateCourseListView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseListCVC.className,
                                                            for: indexPath)
                as? CourseListCVC else { return UICollectionViewCell() }
        cell.setCellType(type: .title)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PrivateCourseListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (UIScreen.main.bounds.width - (self.itemSpacing + 2*self.collectionViewInset.left)) / 2
        let cellHeight = CourseListCVCType.getCellHeight(type: .title, cellWidth: cellWidth)
        
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
}

// MARK: - Section Heading

extension PrivateCourseListView: ListEmptyViewDelegate {
    func emptyViewButtonTapped() {
        self.courseDrawButtonTapped.send()
    }
}
