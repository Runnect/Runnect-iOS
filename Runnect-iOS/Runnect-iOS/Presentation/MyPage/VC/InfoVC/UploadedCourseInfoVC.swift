//
//  UploadedCourseInfoVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/02.
//

import UIKit

import SnapKit
import Then
import Moya

final class UploadedCourseInfoVC: UIViewController {
    
    // MARK: - Properties
  
    private var uploadedCourseProvider = Providers.publicCourseProvider
    
    private var uploadedCourseList = [PublicCourse]()
    
    var isEditMode: Bool = false
    
    private var deleteToCourseId = [Int]()
    // MARK: - Constants
    
    final let uploadedCourseInset: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 25, right: 16)
    final let uploadedCourseLineSpacing: CGFloat = 20
    final let uploadedCourseItemSpacing: CGFloat = 10
    final let uplodaedCourseCellHeight: CGFloat = 124

    // MARK: - UI Components
    private let collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton).setTitle("업로드한 코스")
    
    private lazy var UploadedCourseInfoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()

    private let beforeEditTopView = UIView().then {
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
        frame: .zero, collectionViewLayout: collectionViewLayout).then {
        $0.backgroundColor = .clear
    }

    private let emptyView = ListEmptyView(description: "아직 업로드한 코스가 없어요!\n내가 그린 코스를 공유해보세요",
                                          buttonTitle: "코스 업로드하기")
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
        register()
        setDelegate()
        getUploadedCourseInfo()
        self.setAddTarget()
        self.setDeleteButton()
    }
}

// MARK: - Methods

extension UploadedCourseInfoVC {
    private func setData(courseList: [PublicCourse]) {
        self.uploadedCourseList = courseList
        UploadedCourseInfoCollectionView.reloadData()
        self.emptyView.isHidden = !courseList.isEmpty
        self.deleteCourseButton.isHidden = !courseList.isEmpty
        self.deleteCourseButton.isHidden = courseList.isEmpty
        self.tabBarController?.tabBar.isHidden = false
        self.beforeEditTopView.isHidden = courseList.isEmpty
        totalNumOfRecordlabel.text = "총 기록 \(courseList.count)개"
    }
    
    private func setDelegate() {
        self.UploadedCourseInfoCollectionView.delegate = self
        self.UploadedCourseInfoCollectionView.dataSource = self
        emptyView.delegate = self
        UploadedCourseInfoCollectionView.allowsMultipleSelection = true
    }
    
    private func register() {
        UploadedCourseInfoCollectionView.register(CourseListCVC.self,
                                     forCellWithReuseIdentifier: CourseListCVC.className)
    }
    private func setAddTarget() {
        self.editButton.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)
        
    }
    
    private func setDeleteButton() {
        deleteCourseButton.addTarget(self, action: #selector(deleteCourseButtonDidTap), for: .touchUpInside)
    }
}
// MARK: - @objc Function

extension UploadedCourseInfoVC {
    @objc func deleteCourseButtonDidTap(_sender: UIButton) {
        guard let selectedList = UploadedCourseInfoCollectionView.indexPathsForSelectedItems else { return }
        var deleteToCourseId = [Int]()
        for indexPath in selectedList {
            let publicCourse = uploadedCourseList[indexPath.item]
            deleteToCourseId.append(publicCourse.id)
        }
        
        let deleteAlertVC = RNAlertVC(description: "삭제하시겠습니까?")
        deleteAlertVC.modalPresentationStyle = .overFullScreen
        deleteAlertVC.rightButtonTapAction = {
            deleteAlertVC.dismiss(animated: false)
            self.deleteUploadedCourse(publicCourseIdList: deleteToCourseId)

        }
        self.present(deleteAlertVC, animated: false)
    }
    
    @objc func editButtonDidTap() {
        if isEditMode {
            self.totalNumOfRecordlabel.text = "총 기록 \(self.uploadedCourseList.count)개"
            self.editButton.setTitle("편집", for: .normal)
            self.deleteCourseButton.isEnabled = false
            self.deleteCourseButton.setTitle(title: "삭제하기")
            self.courseListCollectionView.reloadData()
            isEditMode = false
            self.deleteCourseButton.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
            
        } else {
            self.totalNumOfRecordlabel.text = "기록 선택"
            self.editButton.setTitle("취소", for: .normal)
            
            self.deleteCourseButton.isHidden = false
            self.courseListCollectionView.reloadData()
            isEditMode = true
            self.tabBarController?.tabBar.isHidden = true
        }
    }
}

extension UploadedCourseInfoVC {
    
    // MARK: - Layout Helpers
    
    private func setNavigationBar() {
        view.addSubview(navibar)
        
        navibar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
    }
    
    private func setUI() {
        view.backgroundColor = .w1
        UploadedCourseInfoCollectionView.backgroundColor = .w1
        self.emptyView.isHidden = true
        self.beforeEditTopView.isHidden = false
    }
    
    private func setLayout() {
        view.addSubviews(beforeEditTopView, UploadedCourseInfoCollectionView, deleteCourseButton)
        
        UploadedCourseInfoCollectionView.addSubview(emptyView)
        
        beforeEditTopView.addSubviews(totalNumOfRecordlabel, editButton)
        beforeEditTopView.snp.makeConstraints { make in
            make.top.equalTo(navibar.snp.bottom)
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
        
        UploadedCourseInfoCollectionView.snp.makeConstraints {  make in
            make.top.equalTo(editButton.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(80)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UploadedCourseInfoVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let doubleCellWidth = screenWidth - uploadedCourseInset.left - uploadedCourseInset.right - uploadedCourseItemSpacing
        let cellHeight = (doubleCellWidth / 2) * 0.7 + 36
        return CGSize(width: doubleCellWidth / 2, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return uploadedCourseLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return uploadedCourseInset
    }
}

// MARK: - UICollectionViewDataSource

extension UploadedCourseInfoVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uploadedCourseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseListCVC.className, for: indexPath)
                as? CourseListCVC else { return UICollectionViewCell() }
        cell.setCellType(type: .title)
        let model = uploadedCourseList[indexPath.item]
        let cellTitle =  "\(model.departure.region) \(model.departure.city)"
        cell.setData(imageURL: model.image, title: cellTitle, location: nil, didLike: nil)
        
        if isEditMode {
            // selectCell 표시
            if let selectedCells = collectionView.indexPathsForSelectedItems, selectedCells.contains(indexPath) {
                cell.selectCell(didSelect: false)
            }
            else { cell.selectCell(didSelect: true)
            }
        } else {
        cell.setCellType(type: .title)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseListCVC.className,
                                                            for: indexPath)
                as? CourseListCVC else { return UICollectionViewCell() }
        cell.setCellType(type: .title)
    }
        return cell
            }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView.cellForItem(at: indexPath) is CourseListCVC else { return }
        guard let selectedCells = collectionView.indexPathsForSelectedItems else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? CourseListCVC else { return }
        let courseList = uploadedCourseList[indexPath.item]
        
        if isEditMode {
            self.deleteCourseButton.isEnabled = true
            let countSelectCells = selectedCells.count
            self.deleteCourseButton.setTitle(title: "삭제하기(\(countSelectCells))")
            cell.selectCell(didSelect: true)
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
            self.deleteCourseButton.setTitle(title: "삭제하기")
            self.deleteCourseButton.setEnabled(true)
            let courseDetailVC = CourseDetailVC()
            courseDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(courseDetailVC, animated: true)
            cell.selectCell(didSelect: false)
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard collectionView.cellForItem(at: indexPath) is CourseListCVC else { return }
        guard let selectedCells = collectionView.indexPathsForSelectedItems else {
            self.deleteCourseButton.isEnabled = false
            self.deleteCourseButton.setTitle(title: "삭제하기")
            return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? CourseListCVC else { return }
        cell.selectCell(didSelect: false)
        if isEditMode {
            self.deleteCourseButton.isEnabled = true
            let countSelectCells = selectedCells.count
            self.deleteCourseButton.setTitle(title: "삭제하기(\(countSelectCells))")
            cell.selectCell(didSelect: false)
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
            self.deleteCourseButton.setTitle(title: "삭제하기")
            cell.selectCell(didSelect: false)
        }
    }
}

// MARK: - Network

extension UploadedCourseInfoVC {
    func getUploadedCourseInfo() {
        LoadingIndicator.showLoading()
        uploadedCourseProvider.request(.getUploadedCourseInfo) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<PickedMapListResponseDto>.self)
                        guard let data = responseDto.data else { return }
                        self.setData(courseList: data.publicCourses)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                if status >= 400 {
                    print("400 error")
                    self.showNetworkFailureToast()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showNetworkFailureToast()
            }
        }
    }
    private func deleteUploadedCourse(publicCourseIdList: [Int]) {
        LoadingIndicator.showLoading()
        uploadedCourseProvider.request(.deleteUploadedCourse(publicCourseIdList: publicCourseIdList)) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                print("리절트", result)
                let status = result.statusCode
                if 200..<300 ~= status {
                    print("삭제 성공")
                    self.getUploadedCourseInfo()
                }
                if status >= 400 {
                    print("400 error")
                    self.showNetworkFailureToast()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showNetworkFailureToast()
            }
        }
    }
}

// MARK: - Section Heading

extension UploadedCourseInfoVC: ListEmptyViewDelegate {
    func emptyViewButtonTapped() {
        let myCourseSelectVC = MyCourseSelectVC()
        self.navigationController?.pushViewController(myCourseSelectVC, animated: true)
        
    }
}
