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
    
    private let stampCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    // MARK: - Variables
    
    var stampList: [GoalRewardInfoModel] = [
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampC1.className, stampStandard: "그리기 스타터"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampC2.className, stampStandard: "그리기 중수"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampC3.className, stampStandard: "그리기 마스터"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampS1.className, stampStandard: "스크랩 베이비"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampS2.className, stampStandard: "스크랩 어린이"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampS3.className, stampStandard: "스크랩 어른이"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampS3.className, stampStandard: "스크랩 어른이"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampP1.className, stampStandard: "새싹 업로더"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampP2.className, stampStandard: "중수 업로더"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampP3.className, stampStandard: "인플루언서"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampR1.className, stampStandard: "달리기 유망주"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampR2.className, stampStandard: "아마추어 선수"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampR2.className, stampStandard: "마라톤 선수")
    ]
    
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
