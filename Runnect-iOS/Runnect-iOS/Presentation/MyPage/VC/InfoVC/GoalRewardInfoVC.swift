//
//  GoalRewardInfoVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/02.
//

import UIKit
import SnapKit
import Then

final class GoalRewardInfoVC: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton).setTitle("목표 보상")

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        // Do any additional setup after loading the view.
    }
}

// MARK: - Methods
// MARK: - @objc Function

// MARK: - UI & Layout

extension GoalRewardInfoVC {
    private func setNavigationBar() {
        view.addSubview(navibar)
        
        navibar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
    }
    
    private func setUI() {
        view.backgroundColor = .w1
    }
}
