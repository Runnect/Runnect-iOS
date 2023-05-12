//
//  PrivateCourseListView.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/06.
//

import UIKit
import Combine

protocol PrivateCourseListViewDelegate: AnyObject {
    func deleteCourseButtonTapped(courseIdsToDelete: [Int])
}

final class PrivateCourseListView: UIView {
    
    // MARK: - Properties
    
    var courseDrawButtonTapped = PassthroughSubject<Void, Never>()

    var cellDidTapped = PassthroughSubject<Int, Never>()
    var courseDeleteButtonTapped = PassthroughSubject<Void, Never>()

    private var courseList = [PrivateCourse]()
    private var selectedList: [Int] = []
    
    weak var delegate: PrivateCourseListViewDelegate?
    weak var courseStorageVC: UIViewController?
    private var isEditMode: Bool = false
    
    final let collectionViewInset = UIEdgeInsets(top: 28, left: 16, bottom: 28, right: 16)
    final let itemSpacing: CGFloat = 10
    final let lineSpacing: CGFloat = 20
    
    // MARK: - UI Components
    
    private let collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    private let beforeEditTopView = UIView().then{
            $0.backgroundColor = .clear
        }
    
    private lazy var totalNumOfRecordlabel = UILabel().then {
            $0.font = .b6
            $0.textColor = .g2
            $0.text = "총 기록 0개"
        }

        private let editButton = UIButton(type: .custom).then {
            $0.setTitle("편집", for: .normal)
            $0.setTitleColor(.m1, for: .normal)
            $0.titleLabel?.font = .b7
            $0.layer.borderColor = UIColor.m1.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 11
        }

        private lazy var deleteCourseButton = CustomButton(title: "삭제하기").then {
            $0.isHidden = true
            $0.isEnabled = false
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
        self.setAddTarget()
        self.setDeleteButton()
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
        totalNumOfRecordlabel.text = "총 기록 \(courseList.count)개"
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
    
    private func setDeleteButton(){
        deleteCourseButton.addTarget(self, action: #selector(deleteCourseButtonDidTap), for: .touchUpInside)
    }
}
// MARK: - @objc Function

extension PrivateCourseListView {
    
    @objc func deleteCourseButtonDidTap(_sender: UIButton) {
       
        let selectedList = self.selectedList

        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        let deleteVC = RNAlertVC(description: "코스를 정말로 삭제하시겠어요?")
        deleteVC.modalPresentationStyle = .overFullScreen
        rootVC?.present(deleteVC, animated: false)
        deleteVC.rightButtonTapAction = { [weak self] in
            deleteVC.dismiss(animated: false)
            self?.delegate?.deleteCourseButtonTapped(courseIdsToDelete: selectedList)
            
        }
    }

    @objc func editButtonDidTap() {
           if isEditMode {
               self.totalNumOfRecordlabel.text = "총 기록 \(self.courseList.count)개"
               self.editButton.setTitle("편집", for: .normal)
               self.deleteCourseButton.isHidden = true
               self.deleteCourseButton.isEnabled = false
               self.deleteCourseButton.setTitle(title: "삭제하기")
               self.courseListCollectionView.reloadData()
               isEditMode = false
           } else {
               self.totalNumOfRecordlabel.text = "기록 선택"
               self.editButton.setTitle("취소", for: .normal)
               self.deleteCourseButton.isHidden = false
               self.courseListCollectionView.reloadData()
               isEditMode = true
           }
       }
}
// MARK: - UI & Layout

extension PrivateCourseListView {
    private func setUI() {
        self.backgroundColor = .w1
        self.emptyView.isHidden = true
    }
    
    private func setLayout() {
        self.addSubviews(beforeEditTopView, courseListCollectionView, deleteCourseButton)
        courseListCollectionView.addSubviews(emptyView)
        
        beforeEditTopView.addSubviews(totalNumOfRecordlabel, editButton)
        
        beforeEditTopView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(38)
                }
        
        totalNumOfRecordlabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(10)
                }

        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(47)
            make.height.equalTo(22)
            make.top.equalToSuperview().offset(5)
                }
        
        deleteCourseButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
                }
        
        courseListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom)
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
        return courseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseListCVC.className, for: indexPath)
                as? CourseListCVC else { return UICollectionViewCell() }
        cell.setCellType(type: .title)
        if let selectedCells = collectionView.indexPathsForSelectedItems, selectedCells.contains(indexPath) {
            cell.selectCell(didSelect: true)
        } else {
            cell.selectCell(didSelect: false)
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseListCVC.className,
                                                            for: indexPath)
                as? CourseListCVC else { return UICollectionViewCell() }
        cell.setCellType(type: .title)

        let model = courseList[indexPath.item]
        let cellTitle =  "\(model.departure.region) \(model.departure.city)"
        cell.setData(imageURL: model.image, title: cellTitle, location: nil, didLike: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.cellForItem(at: indexPath) is CourseListCVC else { return }
        guard let selectedCells = collectionView.indexPathsForSelectedItems else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? CourseListCVC else { return }
        let courseList = courseList[indexPath.item]
        
        if isEditMode {
            self.deleteCourseButton.isEnabled = true
            let countSelectCells = selectedCells.count
            self.deleteCourseButton.setTitle(title: "삭제하기(\(countSelectCells))")
            cell.selectCell(didSelect: true)
//            self.selectedIndexs = indexPath.item
            courseDeleteButtonTapped.send()
         
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
            self.deleteCourseButton.setTitle(title: "삭제하기")
            cellDidTapped.send(indexPath.item)
//            self.selectedIndexs = indexPath.item
            self.deleteCourseButton.setEnabled(true)
        }
        }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard collectionView.cellForItem(at: indexPath) is CourseListCVC else { return }
        guard let selectedCells = collectionView.indexPathsForSelectedItems else {
            self.deleteCourseButton.isEnabled = false
            self.deleteCourseButton.setTitle(title: "삭제하기")
            return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? CourseListCVC else { return }
        
        if isEditMode {
            self.deleteCourseButton.isEnabled = true
            let countSelectCells = selectedCells.count
            self.deleteCourseButton.setTitle(title: "삭제하기(\(countSelectCells))")
//            self.selectedIndexs = nil
            cell.selectCell(didSelect: false)
        } else {
                collectionView.deselectItem(at: indexPath, animated: true)
                self.deleteCourseButton.setTitle(title: "삭제하기")
            }
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
