//
//  GoalRewardInfoVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/02.
//

import UIKit

import SnapKit
import Then
import Moya

final class GoalRewardInfoVC: UIViewController {
    
    // MARK: - Properties
    private var goalRewardProvider = MoyaProvider<MyPageRouter>(
        plugins: [NetworkLoggerPlugin(verbose: true)]
    )
    
    var stampNameList: [GoalRewardInfoModel] = [
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampC1, stampStandard: "그린 코스 1개"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampC2, stampStandard: "그린 코스 5개"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampC3, stampStandard: "그린 코스 10개"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampS1, stampStandard: "스크랩 1회"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampS2, stampStandard: "스크랩 5회"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampS3, stampStandard: "스크랩 10회"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampP1, stampStandard: "업로드 1회"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampP2, stampStandard: "업로드 5회"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampP3, stampStandard: "업로드 10회"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampR1, stampStandard: "달리기 1회"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampR2, stampStandard: "달리기 5회"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampR2, stampStandard: "달리기 10회")
    ]
    
    private var goalRewardList = [GoalRewardStamp]()
    var isStampExistList = Array(repeating: false, count: 12)
    
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
        
        return collectionView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
        setDelegate()
        register()
        getGoalRewardInfo()
    }
}

// MARK: - Methods

extension GoalRewardInfoVC {
    private func setDelegate() {
        stampCollectionView.delegate = self
        stampCollectionView.dataSource = self
    }

    private func register() {
        stampCollectionView.register(GoalRewardInfoCVC.self,
                                     forCellWithReuseIdentifier: GoalRewardInfoCVC.className)
    }
    
    func setIsStampExistList(list: [GoalRewardStamp]) {
        let stampNameDictionary: [String: Int] = ["c1": 0, "c2": 1, "c3": 2,
                                                  "s1": 3, "s2": 4, "s3": 5,
                                                  "u1": 6, "u2": 7, "u3": 8,
                                                  "r1": 9, "r2": 10, "r3": 11]
        
        for stamp in list {
            guard let index = stampNameDictionary[stamp.id] else { return }
            self.isStampExistList[index] = true
        }
        
        print(isStampExistList)
        
        stampCollectionView.reloadData()
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
        }
        
        stampTopView.addSubviews(stampImage, stampExcourageLabel)
        
        stampImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.centerX.equalToSuperview()
            make.width.equalTo(139)
            make.height.equalTo(126)
        }
        
        stampExcourageLabel.snp.makeConstraints { make in
            make.top.equalTo(stampImage.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(37)
        }
        
        stampCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stampTopView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GoalRewardInfoVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let tripleCellWidth = screenWidth - stampInset.left - stampInset.right - stampItemSpacing * 2
        let cellHeight = tripleCellWidth / 3 + 22
        return CGSize(width: tripleCellWidth / 3, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return stampLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return stampInset
    }
}

// MARK: - UICollectionViewDataSource

extension GoalRewardInfoVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stampNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let stampCell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalRewardInfoCVC.className, for: indexPath) as? GoalRewardInfoCVC else { return UICollectionViewCell()}
        stampCell.setStampImageView(model: stampNameList[indexPath.item], item: isStampExistList[indexPath.item])
        print(indexPath.item)
        stampCell.setStampNameLabel(model: stampNameList[indexPath.item])
        return stampCell
    }
}

// MARK: - Network

extension GoalRewardInfoVC {
    func getGoalRewardInfo() {
        LoadingIndicator.showLoading()
        goalRewardProvider.request(.getGoalRewardInfo) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<GoalRewardInfoDto>.self)
                        guard let data = responseDto.data else { return }
                        self.setIsStampExistList(list: data.stamps)
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
