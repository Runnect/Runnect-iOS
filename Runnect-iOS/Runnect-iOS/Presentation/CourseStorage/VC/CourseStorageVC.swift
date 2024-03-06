//
//  CourseStorageVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit
import Combine

import Moya
import SnapKit
import Then

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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if privateCourseListView.isEditMode {
            self.finishEditMode(withDuration: 0)
        }
    }
}

// MARK: - Methods

extension CourseStorageVC {
    private func setPrivateCourseData(courseList: [PrivateCourse]) {
        self.privateCourseList = courseList
        self.privateCourseListView.setData(courseList: courseList)
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
        viewPager.$selectedTabIndex.sink { [weak self] selectedTabIndex in
            guard let self = self else { return }
            self.deleteCourseButton.isHidden = (selectedTabIndex != 0)
        }.store(in: cancelBag)
        
        privateCourseListView.courseDrawButtonTapped.sink { [weak self] in
            guard let self = self else { return }
            
            analyze(buttonName: GAEvent.Button.clickMyStorageCourseDrawingStart) // 내가 그린 코스 코스 그리기 진입
            self.tabBarController?.selectedIndex = 0
        }.store(in: cancelBag)
        
        scrapCourseListView.scrapButtonTapped.sink { [weak self] in
            guard let self = self else { return }
            self.tabBarController?.selectedIndex = 2
        }.store(in: cancelBag)
        
        privateCourseListView.cellDidTapped.sink { [weak self] index in
            guard let self = self else { return }
            analyze(buttonName: GAEvent.Button.clickScrapPageStartCourse) // 코스 발견_스크랩코스 상세페이지 시작하기 Event
            
            let title = self.privateCourseList[index].title
            let runningWaitingVC = RunningWaitingVC()
            runningWaitingVC.setData(courseId: self.privateCourseList[index].id, publicCourseId: nil, courseTitle: title)
            
            /// 코스 이름을 여기서 가져오는 로직
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
    
    private func hideTabBarWithAnimation(duration: TimeInterval = 0.7) {
        if let frame = tabBarController?.tabBar.frame {
            let factor: CGFloat = 1
            let y = frame.origin.y + (frame.size.height * factor)
            UIView.animate(withDuration: duration, animations: {
                self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
            })
        }
    }
    
    private func showTabBarWithAnimation(duration: TimeInterval = 0.7) {
        if let frame = tabBarController?.tabBar.frame {
            let factor: CGFloat = -1
            let y = frame.origin.y + (frame.size.height * factor)
            UIView.animate(withDuration: duration, animations: {
                self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
            })
        }
    }
    
    private func finishEditMode(withDuration: TimeInterval = 0) {
        self.privateCourseListView.isEditMode = false
        
        showTabBarWithAnimation(duration: withDuration)
        self.deleteCourseButton.setEnabled(false)
        self.deleteCourseButton.setTitle(title: "삭제하기")
        
        UIView.animate(withDuration: withDuration) {
            self.deleteCourseButton.transform = CGAffineTransform(translationX: 0, y: 34)
        }
    }
    
    private func startEditMode(withDuration: TimeInterval = 0) {
        self.privateCourseListView.isEditMode = true
        
        hideTabBarWithAnimation(duration: withDuration)
        
        view.bringSubviewToFront(deleteCourseButton)
        UIView.animate(withDuration: withDuration) {
            self.deleteCourseButton.transform = CGAffineTransform(translationX: 0, y: -34)
        }
    }
}

// MARK: - @objc Function

extension CourseStorageVC {
    @objc func deleteCourseButtonDidTap(_sender: UIButton) {
        guard let selectedList = privateCourseListView.courseListCollectionView.indexPathsForSelectedItems else {
            return
        }
        
        var deleteToCourseId = [Int]()
        
        for indexPath in selectedList {
            let privateCourse = privateCourseList[indexPath.item]
            deleteToCourseId.append(privateCourse.id)
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
        
        naviBar.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        
        guard UserManager.shared.userType != .visitor else {
            self.showSignInRequestEmptyView()
            analyze(buttonName: GAEvent.Button.clickJoinInStorage)
            return
        }
        
        view.addSubviews(viewPager, deleteCourseButton)
        
        viewPager.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        deleteCourseButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
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
        privateCourseListView.isEditMode ? startEditMode(withDuration: 0.7) : finishEditMode(withDuration: 0.7)
    }
    
    func selectCellDidTapped() {
        guard let selectedCells = privateCourseListView.courseListCollectionView.indexPathsForSelectedItems else { return }
        
        let countSelectCells = selectedCells.count
        
        if privateCourseListView.isEditMode == true {
            self.deleteCourseButton.setTitle(title: "삭제하기(\(countSelectCells))")
        }
        
        self.deleteCourseButton.setEnabled(countSelectCells != 0)
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
            self.privateCourseListView.isEditMode = false
            switch response {
            case .success(let result):
                print("리절트", result)
                let status = result.statusCode
                if 200..<300 ~= status {
                    print("삭제 성공")
                    self.getPrivateCourseList()
                    self.finishEditMode(withDuration: 0.7)
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
