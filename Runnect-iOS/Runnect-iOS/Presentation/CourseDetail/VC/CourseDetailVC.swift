//
//  CourseDetailVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/05.
//

import UIKit
import SnapKit
import Then

final class CourseDetailVC: UIViewController {
    
    // MARK: - UI Components
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton)
    private let middleScorollView = UIScrollView()
    private let bottomView = UIView()
    
    private let likeButton = UIButton()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
    }
}

extension CourseDetailVC {
    
    // MARK: - Layout Helpers
    private func setNavigationBar() {
        view.addSubview(navibar)
        
        navibar.snp.makeConstraints {  make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
    }
    
    private func setUI() {
        view.backgroundColor = .w1
        bottomView.backgroundColor = .blue
        middleScorollView.backgroundColor = .brown
    }
    
    private func setLayout() {
        view.addSubviews(middleScorollView, bottomView)
        
        bottomView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(84)
        }
        
        middleScorollView.snp.makeConstraints { make in
            make.top.equalTo(navibar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}
