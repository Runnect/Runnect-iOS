//
//  CourseStorageVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit
import Combine

final class CourseStorageVC: UIViewController {
    
    // MARK: - Properties
    
    private let cancelBag = CancelBag()
    
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
}

// MARK: - Methods

extension CourseStorageVC {
    private func bindUI() {
        privateCourseListView.courseDrawButtonTapped.sink {
            self.tabBarController?.selectedIndex = 0
        }.store(in: cancelBag)
        
        scrapCourseListView.scrapButtonTapped.sink {
            self.tabBarController?.selectedIndex = 2
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
