//
//  CourseStorageVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit
import Combine

import Moya

final class CourseStorageVC: UIViewController {
    
    // MARK: - Properties
    private let courseProvider = Providers.courseProvider
    
    private let scrapProvider = Providers.scrapProvider
    
    private let cancelBag = CancelBag()
    
    private var privateCourseList = [PrivateCourse]()
    
    private var scrapCourseList = [ScrapCourse]()
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .title).setTitle("보관함")
    
    private let privateCourseListView = PrivateCourseListView()
    
    private let scrapCourseListView = ScrapCourseListView()
    
    private lazy var viewPager = ViewPager(pageTitles: ["내가 그린 코스", "스크랩 코스"])
        .addPagedView(pagedView: [privateCourseListView, scrapCourseListView])
    
    private var deleteCourseButton = CustomButton(title: "삭제하기").then {
        $0.isHidden = true
        $0.isEnabled = false
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.bindUI()
        self.setDelegate()
        self.setDeleteButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard UserManager.shared.userType != .visitor else { return }
        self.getPrivateCourseList()
        self.getScrapCourseList()
    }
}

// MARK: - Methods

extension CourseStorageVC {
    private func setPrivateCourseData(courseList: [PrivateCourse]) {
        self.privateCourseList = courseList
        self.privateCourseListView.setData(courseList: courseList)
        self.deleteCourseButton.isHidden = true
        self.hideTabBar(wantsToHide: false)
    }
    
    private func setScrapCourseData(courseList: [ScrapCourse]) {
        self.scrapCourseList = courseList
        self.scrapCourseListView.setData(courseList: courseList)
    }
    
    private func setDeleteButton() {
        deleteCourseButton.addTarget(self, action: #selector(deleteCourseButtonDidTap), for: .touchUpInside)
    }
    
    private func bindUI() {
        privateCourseListView.courseDrawButtonTapped.sink { [weak self] in
            guard let self = self else { return }
            self.tabBarController?.selectedIndex = 0
        }.store(in: cancelBag)
        
        scrapCourseListView.scrapButtonTapped.sink { [weak self] in
            guard let self = self else { return }
            self.tabBarController?.selectedIndex = 2
        }.store(in: cancelBag)
        
        privateCourseListView.cellDidTapped.sink { [weak self] index in
            guard let self = self else { return }
            let runningWaitingVC = RunningWaitingVC()
            runningWaitingVC.setData(courseId: self.privateCourseList[index].id, publicCourseId: nil)
            runningWaitingVC.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(runningWaitingVC, animated: true)
        }.store(in: cancelBag)
        
        scrapCourseListView.cellDidTapped.sink { [weak self] index in
            guard let self = self else { return }
            let courseDetailVC = CourseDetailVC()
            let model = self.scrapCourseList[index]
            courseDetailVC.setCourseId(courseId: model.courseId, publicCourseId: model.publicCourseId)
            courseDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(courseDetailVC, animated: true)
        }.store(in: cancelBag)
    }
    
    private func setDelegate() {
        scrapCourseListView.delegate = self
        privateCourseListView.delegate = self
    }
    
    private func showHiddenViews(withDuration: TimeInterval = 0) {
        if let frame = tabBarController?.tabBar.frame {
            let factor: CGFloat = -1
            let y = frame.origin.y + (frame.size.height * factor)
            UIView.animate(withDuration: 0.7, animations: {
                self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
            })
        }
        UIView.animate(withDuration: withDuration) {
            self.deleteCourseButton.transform = CGAffineTransform(translationX: 0, y: 34)
        }
    }
    
    private func hiddenViews(withDuration: TimeInterval = 0) {
        if let frame = tabBarController?.tabBar.frame {
            let factor: CGFloat = 1
            let y = frame.origin.y + (frame.size.height * factor)
            UIView.animate(withDuration: 0.7, animations: {
                self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
            })
        }
        view.bringSubviewToFront(deleteCourseButton)
        UIView.animate(withDuration: withDuration) {
            self.deleteCourseButton.transform = CGAffineTransform(translationX: 0, y: -34)
        }
    }
}

// MARK: - @objc Function

extension CourseStorageVC {
    @objc func deleteCourseButtonDidTap(_sender: UIButton) {
        guard let selectedList = privateCourseListView.courseListCollectionView.indexPathsForSelectedItems else { return }
        var deleteToCourseId = [Int]()
        for indexPath in selectedList {
            let publicCourse = privateCourseList[indexPath.item]
            deleteToCourseId.append(publicCourse.id)
        }
        let deleteAlertVC = RNAlertVC(description: "삭제하시겠습니까?")
        deleteAlertVC.modalPresentationStyle = .overFullScreen
        deleteAlertVC.rightButtonTapAction = {
            deleteAlertVC.dismiss(animated: false)
            self.deleteCourse(courseIdList: deleteToCourseId)
        }
        self.present(deleteAlertVC, animated: false)
    }
}

// MARK: - UI & Layout

extension CourseStorageVC {
    private func setUI() {
        view.backgroundColor = .w1
    }
    private func setLayout() {
        view.addSubviews(naviBar)

        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }

        
        guard UserManager.shared.userType != .visitor else {
            self.showSignInRequestEmptyView()
            return
        }
        
        view.addSubviews(viewPager, deleteCourseButton)
        
        viewPager.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        deleteCourseButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(34)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
    }
}

// MARK: - ScrapCourseListViewDelegate

extension CourseStorageVC: ScrapCourseListViewDelegate {
    func likeButtonTapped(wantsTolike: Bool, publicCourseId: Int) {
        scrapCourse(publicCourseId: publicCourseId, scrapTF: wantsTolike)
    }
}

// MARK: - PrivateCourseListViewDelegate

extension CourseStorageVC: PrivateCourseListViewDelegate {
    
    func courseListEditButtonTapped() {
        if privateCourseListView.isEditMode == false {
            self.deleteCourseButton.isHidden = false
            self.deleteCourseButton.isEnabled = false
            self.deleteCourseButton.setTitle(title: "삭제하기")
            hiddenViews(withDuration: 0.7)
        }
        if privateCourseListView.isEditMode == true {
            self.hideTabBar(wantsToHide: false)
            self.deleteCourseButton.isHidden = false
            showHiddenViews(withDuration: 0.7)
        }
    }
    func selectCellDidTapped() {
        guard let selectedCells = privateCourseListView.courseListCollectionView.indexPathsForSelectedItems else { return }
        let countSelectCells = selectedCells.count
        if privateCourseListView.isEditMode == true {
            if privateCourseListView.isEditMode == false {
                self.deleteCourseButton.isEnabled = false
                self.deleteCourseButton.setTitle(title: "삭제하기")
            }
            self.deleteCourseButton.setTitle(title: "삭제하기(\(countSelectCells))")
            self.deleteCourseButton.isEnabled = false
            self.deleteCourseButton.setEnabled(true)
        }
        if selectedCells.count == 0 {
            self.deleteCourseButton.isEnabled = false
        }
    }
}
// MARK: - Network
extension CourseStorageVC {
    private func getPrivateCourseList() {
        LoadingIndicator.showLoading()
        courseProvider.request(.getAllPrivateCourse) { [weak self] response in
            guard let self = self else { return }
            LoadingIndicator.hideLoading()
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<PrivateCourseResponseDto>.self)
                        guard let data = responseDto.data else { return }
                        self.setPrivateCourseData(courseList: data.courses)
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
    
    private func getScrapCourseList() {
        LoadingIndicator.showLoading()
        scrapProvider.request(.getScrapCourse) { [weak self] response in
            guard let self = self else { return }
            LoadingIndicator.hideLoading()
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<ScrapCourseResponseDto>.self)
                        guard let data = responseDto.data else { return }
                        self.setScrapCourseData(courseList: data.scraps)
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
    
    private func scrapCourse(publicCourseId: Int, scrapTF: Bool) {
        LoadingIndicator.showLoading()
        scrapProvider.request(.createAndDeleteScrap(publicCourseId: publicCourseId, scrapTF: scrapTF)) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    self.getScrapCourseList()
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
    
    private func deleteCourse(courseIdList: [Int]) {
        LoadingIndicator.showLoading()
        courseProvider.request(.deleteCourse(courseIdList: courseIdList)) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                print("리절트", result)
                let status = result.statusCode
                if 200..<300 ~= status {
                    print("삭제 성공")
                    self.getPrivateCourseList()
                    self.showHiddenViews(withDuration: 0.7)
                    
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
