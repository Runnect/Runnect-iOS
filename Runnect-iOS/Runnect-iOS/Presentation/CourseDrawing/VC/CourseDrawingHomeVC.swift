//
//  CourseDrawingHomeVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit

final class CourseDrawingHomeVC: UIViewController, CustomNavigationBarDelegate {
    lazy var naviBar = CustomNavigationBar(self, type: .title).setTitle("보관함")
//     lazy var naviBar = CustomNavigationBar(self, type: .titleWithLeftButton)
//    lazy var naviBar = CustomNavigationBar(self, type: .titleWithLeftButton).setTitle("목표 보상")
//    lazy var naviBar = CustomNavigationBar(self, type: .search).showKeyboard().setTextFieldPlaceholder(placeholder: "출발지 검색")
    
    let button = CustomButton(title: "코스 그리기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        naviBar.delegate = self
        
        view.addSubviews(naviBar, button)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        button.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
    
    func searchButtonDidTap(text: String) {
        print(text)
    }
}
