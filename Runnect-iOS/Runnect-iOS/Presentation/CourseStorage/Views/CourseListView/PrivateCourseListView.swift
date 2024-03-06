//
//  PrivateCourseListView.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/06.
//

import UIKit
import Combine

import SnapKit
import Then

protocol PrivateCourseListViewDelegate: AnyObject {
    func courseListEditButtonTapped()
    func selectCellDidTapped()
}

final class PrivateCourseListView: UIView {
    
    // MARK: - Properties
    
    var courseDrawButtonTapped = PassthroughSubject<Void, Never>()
    
    var cellDidTapped = PassthroughSubject<Int, Never>()
    
    var courseList = [PrivateCourse]()
    
    weak var delegate: PrivateCourseListViewDelegate?
    
    weak var courseStorageVC: UIViewController?
    
    var isEditMode: Bool = false {
        didSet {
            isEditMode ? startEditMode() : finishEditMode()
        }
    }
    
    final let collectionViewInset = UIEdgeInsets(top: 28, left: 16, bottom: 28, right: 16)
    final let itemSpacing: CGFloat = 10
    final let lineSpacing: CGFloat = 20
    
    // MARK: - UI Components
    
    private let collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    private let beforeEditTopView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var totalNumOfRecordlabel = UILabel().then {
        $0.font = .b6
        $0.textColor = .g2
        $0.text = "총 코스 0개"
    }
    
    private let editButton = UIButton(type: .custom).then {
        $0.setTitle("선택", for: .normal)
        $0.setTitleColor(.m1, for: .normal)
        $0.titleLabel?.font = .b5
        $0.layer.backgroundColor = UIColor.m3.cgColor
        $0.layer.cornerRadius = 11
        //        $0.layer.borderColor = UIColor.m1.cgColor
        //        $0.layer.borderWidth = 1
    }
    
    lazy var courseListCollectionView = UICollectionView(
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
        self.setAddTarget()
        self.register()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension PrivateCourseListView {
    func setData(courseList: [PrivateCourse]) {
        self.courseList = courseList
        self.courseListCollectionView.reloadData()
        self.emptyView.isHidden = !courseList.isEmpty
        self.beforeEditTopView.isHidden = courseList.isEmpty
        totalNumOfRecordlabel.text = "총 코스 \(courseList.count)개"
    }
    
    private func setDelegate() {
        courseListCollectionView.delegate = self
        courseListCollectionView.dataSource = self
        courseListCollectionView.allowsMultipleSelection = true
        emptyView.delegate = self
    }
    
    private func register() {
        courseListCollectionView.register(CourseListCVC.self,
                                          forCellWithReuseIdentifier: CourseListCVC.className)
    }
    
    private func setAddTarget() {
        self.editButton.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)
        
    }
}

extension PrivateCourseListView {
    @objc func editButtonDidTap() {
        isEditMode.toggle()
        self.delegate?.courseListEditButtonTapped()
        self.courseListCollectionView.reloadData()
    }
    
    private func startEditMode() {
        self.totalNumOfRecordlabel.text = "코스 선택"
        self.editButton.setTitle("취소", for: .normal)
    }
    
    private func finishEditMode() {
        self.totalNumOfRecordlabel.text = "총 코스 \(self.courseList.count)개"
        self.editButton.setTitle("선택", for: .normal)
        self.deselectAllItems()
    }
    
    private func deselectAllItems() {
        guard let selectedItems = courseListCollectionView.indexPathsForSelectedItems else { return }
        for indexPath in selectedItems { courseListCollectionView.deselectItem(at: indexPath, animated: false) }
    }
}

// MARK: - UI & Layout

extension PrivateCourseListView {
    
    private func setUI() {
        self.backgroundColor = .w1
        self.emptyView.isHidden = true
        self.beforeEditTopView.isHidden = false
    }
    
    private func setLayout() {
        self.addSubviews(beforeEditTopView, courseListCollectionView)
        courseListCollectionView.addSubviews(emptyView)
        beforeEditTopView.addSubviews(totalNumOfRecordlabel, editButton)
        beforeEditTopView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(38)
        }
        
        totalNumOfRecordlabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(10)
        }
        
        editButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(47)
            $0.height.equalTo(22)
            $0.top.equalToSuperview().offset(8)
        }
        
        courseListCollectionView.snp.makeConstraints {
            $0.top.equalTo(editButton.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(80)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PrivateCourseListView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseListCVC.className, for: indexPath) as? CourseListCVC else {
            return UICollectionViewCell()
        }
        
        let model = courseList[indexPath.item]
        let cellTitle = model.title
        
        cell.setCellType(type: .title)
        cell.selectCell(didSelect: collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false)
        cell.setData(imageURL: model.image, title: cellTitle, location: nil, didLike: nil, isEditMode: isEditMode)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CourseListCVC else { return }
        if isEditMode {
            cell.selectCell(didSelect: true)
            delegate?.selectCellDidTapped()
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
            cellDidTapped.send(indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CourseListCVC else { return }
        
        if isEditMode {
            cell.selectCell(didSelect: false)
        }
        delegate?.selectCellDidTapped()
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
