//
//  CourseStorageVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit

final class CourseStorageVC: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .title).setTitle("보관함")
    
    private let myCourseView = UIView().then {
        $0.backgroundColor = .w1
    }
    
    private let scrapCourseView = UIView().then {
        $0.backgroundColor = .w1
    }
    
    private lazy var viewPager = ViewPager(pageTitles: ["내가 그린 코스", "스크랩 코스"])
        .addPagedView(pagedView: [myCourseView, scrapCourseView])
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
    }
}

// MARK: - Methods

extension CourseStorageVC {
    
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
