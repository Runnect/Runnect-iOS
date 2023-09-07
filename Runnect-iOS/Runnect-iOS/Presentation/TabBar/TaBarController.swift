//
//  TabBarController.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTabBarControllers()
    }
}

// MARK: - Methods

extension TabBarController {
    private func setUI() {
        tabBar.backgroundColor = .white
        tabBar.unselectedItemTintColor = .g3
        tabBar.tintColor = .m1
        tabBar.layer.cornerRadius = 20
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.applyShadow(alpha: 0.03, y: -4, blur: 5)
    }
    
    private func setTabBarControllers() {
        let courseDrawingNVC = templateNavigationController(title: "코스 그리기",
                                                           unselectedImage: ImageLiterals.icCourseDraw,
                                                           selectedImage: ImageLiterals.icCourseDrawFill,
                                                           rootViewController: CourseDrawingHomeVC())
        let courseStorageNVC = templateNavigationController(title: "보관함",
                                                         unselectedImage: ImageLiterals.icStorage,
                                                         selectedImage: ImageLiterals.icStorageFill,
                                                         rootViewController: CourseStorageVC())
        let courseDiscoveryNVC = templateNavigationController(title: "코스 발견",
                                                         unselectedImage: ImageLiterals.icCourseDiscover,
                                                         selectedImage: ImageLiterals.icCourseDiscoverFill,
                                                         rootViewController: CourseDiscoveryVC())
        let myPageNVC = templateNavigationController(title: "마이페이지",
                                                         unselectedImage: ImageLiterals.icMypage,
                                                         selectedImage: ImageLiterals.icMypageFill,
                                                         rootViewController: MyPageVC())
        
        viewControllers = [courseDrawingNVC, courseStorageNVC, courseDiscoveryNVC, myPageNVC]
    }
    
    private func templateNavigationController(title: String, unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.title = title
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.isHidden = true
        return nav
    }
    
    
}
