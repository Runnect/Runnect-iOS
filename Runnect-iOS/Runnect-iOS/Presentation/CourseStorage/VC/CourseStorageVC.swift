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
    
    private let courseStorageProvider = MoyaProvider<CourseStorageRouter>(
        plugins: [NetworkLoggerPlugin(verbose: true)]
    )
    
    private let cancelBag = CancelBag()
    
    private var privateCourseList = [PrivateCourse]()
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .title).setTitle("보관함")
    
    private let privateCourseListView = PrivateCourseListView()
    
    private let scrapCourseListView = ScrapCourseListView()
    
    private lazy var viewPager = ViewPager(pageTitles: ["내가 그린 코스", "스크랩 코스"])
        .addPagedView(pagedView: [privateCourseListView, scrapCourseListView])
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getPrivateCourseList()
    }
}

// MARK: - Methods

extension CourseStorageVC {
    private func setPrivateCourseData(courseList: [PrivateCourse]) {
        self.privateCourseList = courseList
        self.privateCourseListView.setData(courseList: courseList)
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
            courseDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(courseDetailVC, animated: true)
        }.store(in: cancelBag)
    }
}

// MARK: - UI & Layout

extension CourseStorageVC {
    private func setUI() {
        view.backgroundColor = .w1
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, viewPager)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        viewPager.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Network

extension CourseStorageVC {
    private func getPrivateCourseList() {
        LoadingIndicator.showLoading()
        courseStorageProvider.request(.getAllPrivateCourse) { [weak self] response in
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
}
