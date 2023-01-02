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
    private let stampTopView = UIView()
    private let stampBottomView = UIView()
    
    private let stampImage = UIImageView().then {
        $0.image = ImageLiterals.imgStamp
    }
    
    private let stampExcourageLabel = UILabel().then {
        $0.text = "다양한 코스를 달리며 러닝 스탬프를 모아봐요"
        $0.textColor = .g2
        $0.font = .b4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
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
        stampBottomView.backgroundColor = .m3
    }
    
    private func setLayout() {
        view.addSubviews(stampTopView, stampBottomView)
        
        stampTopView.snp.makeConstraints { make in
            make.top.equalTo(navibar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(235)
        }
        
        stampTopView.addSubviews(stampImage, stampExcourageLabel)
        
        stampImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(181)
            make.height.equalTo(167)
        }
        
        stampExcourageLabel.snp.makeConstraints { make in
            make.top.equalTo(stampImage.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        stampBottomView.snp.makeConstraints { make in
            make.top.equalTo(stampTopView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).inset(80)
        }
    }
}
