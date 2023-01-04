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
    
    // MARK: - Properties
    
    var stampList: [GoalRewardInfoModel] = [
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampC1, stampStandard: "그리기 스타터"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampC2, stampStandard: "그리기 중수"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampC3, stampStandard: "그리기 마스터"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampS1, stampStandard: "스크랩 베이비"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampS2, stampStandard: "스크랩 어린이"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampS3, stampStandard: "스크랩 어른이"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampP1, stampStandard: "새싹 업로더"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampP2, stampStandard: "중수 업로더"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampP3, stampStandard: "인플루언서"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampR1, stampStandard: "달리기 유망주"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampR2, stampStandard: "아마추어 선수"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampR2, stampStandard: "마라톤 선수")
    ]
    
    // MARK: - Constants
    
    final let stampInset: UIEdgeInsets = UIEdgeInsets(top: 32, left: 34, bottom: 10, right: 34)
    final let stampLineSpacing: CGFloat = 20
    final let stampItemSpacing: CGFloat = 26
    final let stampCellHeight: CGFloat = 112
    
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton).setTitle("목표 보상")
    private let stampTopView = UIView()
    
    private let stampImage = UIImageView().then {
        $0.image = ImageLiterals.imgStamp
    }
    
    private let stampExcourageLabel = UILabel().then {
        $0.text = "다양한 코스를 달리며 러닝 스탬프를 모아봐요"
        $0.textColor = .g2
        $0.font = .b4
    }
    
    private lazy var stampCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
        register()
    }
}

extension GoalRewardInfoVC {
    
    // MARK: - Layout Helpers
    
    private func setNavigationBar() {
        view.addSubview(navibar)
        
        navibar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
    }
    
    private func setUI() {
        view.backgroundColor = .w1
        stampCollectionView.backgroundColor = .m3
    }
    
    private func setLayout() {
        view.addSubviews(stampTopView, stampCollectionView)
        
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
        
        stampCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stampTopView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - General Helpers

    private func register() {
        stampCollectionView.register(GoalRewardInfoCVC.self,
                                     forCellWithReuseIdentifier: GoalRewardInfoCVC.className)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GoalRewardInfoVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let tripleCellWidth = screenWidth - stampInset.left - stampInset.right - stampItemSpacing * 2
        return CGSize(width: tripleCellWidth / 3, height: 112)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return stampLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return stampLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return stampInset
    }
}

// MARK: - UICollectionViewDataSource

extension GoalRewardInfoVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stampList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let stampCell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalRewardInfoCVC.className, for: indexPath) as? GoalRewardInfoCVC else { return UICollectionViewCell()}
        stampCell.dataBind(model: stampList[indexPath.item])
        return stampCell
    }
}
