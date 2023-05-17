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
    private var stampProvider = Providers.stampProvider
    
    var stampNameList: [GoalRewardInfoModel] = GoalRewardInfoModel.stampNameList
    
    private var goalRewardList = [GoalRewardStamp]()
    let stampNameDictionary: [String: Int] = ["c1": 0, "c2": 1, "c3": 2,
                                              "s1": 3, "s2": 4, "s3": 5,
                                              "u1": 6, "u2": 7, "u3": 8,
                                              "r1": 9, "r2": 10, "r3": 11]
    var isStampExistList = Array(repeating: false, count: 12)
    
    // MARK: - Constants
    
    final let stampInset: UIEdgeInsets = UIEdgeInsets(top: 32, left: 34, bottom: 20, right: 34)
    final let stampLineSpacing: CGFloat = 20
    final let stampItemSpacing: CGFloat = 26
    final let stampCellHeight: CGFloat = 112
    
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton).setTitle("목표 보상")
        
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
        self.hideTabBar(wantsToHide: true)
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
        stampCollectionView.register(GoalRewardTitleCVC.self,
                                     forCellWithReuseIdentifier:
                                        GoalRewardTitleCVC.className)
    }
    
    func setIsStampExistList(list: [GoalRewardStamp]) {
        for stamp in list {
            guard let index = stampNameDictionary[stamp.id] else { return }
            self.isStampExistList[index] = true
        }
        
        stampCollectionView.reloadData()
    }
}

// MARK: - Layout Helpers

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
        stampCollectionView.backgroundColor = .m3
    }
    
    private func setLayout() {
        view.addSubview(stampCollectionView)
        
        stampCollectionView.snp.makeConstraints { make in
            make.top.equalTo(navibar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GoalRewardInfoVC: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        
        if indexPath.section == 0 {
            return CGSize(width: screenWidth, height: 227)
        } else {
            let tripleCellWidth = screenWidth - stampInset.left - stampInset.right - stampItemSpacing * 2
            let cellHeight = tripleCellWidth / 3 + 22
            return CGSize(width: tripleCellWidth / 3, height: cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 { return 0 }
        return stampLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 { return .zero }
        return stampInset
    }
}

// MARK: - UICollectionViewDataSource

extension GoalRewardInfoVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return stampNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalRewardTitleCVC.className, for: indexPath) as? GoalRewardTitleCVC else { return UICollectionViewCell()}
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalRewardInfoCVC.className, for: indexPath) as? GoalRewardInfoCVC else { return UICollectionViewCell()}
            cell.setData(model: stampNameList[indexPath.item], item: isStampExistList[indexPath.item])
            return cell
        }
    }
}

// MARK: - Network

extension GoalRewardInfoVC {
    func getGoalRewardInfo() {
        LoadingIndicator.showLoading()
        stampProvider.request(.getGoalRewardInfo) { [weak self] response in
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
