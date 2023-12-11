//
//  UserInfoCell.swift
//  Runnect-iOS
//
//  Created by 이명진 on 12/11/23.
//

import UIKit

class UserInfoCell: UICollectionViewCell {
    
    
    // MARK: - properties
    
    private let stampNameImageDictionary: [String: UIImage] = GoalRewardInfoModel.stampNameImageDictionary
    
    // MARK: - UI Components
    
    private let myProfileInfoView = UIView()
    private var myProfileImage = UIImageView()
    private var myProfileStamp: String?
    private var myProfileNameLabel = UILabel().then {
        $0.textColor = .m1
        $0.font = .h4
        $0.text = "ㅎㅇ"
    }
    
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    // MARK: - Layout Helpers

extension UserInfoCell {
    
    private func setUI() {
        contentView.addSubview(myProfileInfoView)
        myProfileInfoView.backgroundColor = .clear
    }
    private func setLayout() {
        myProfileInfoView.addSubviews(myProfileImage, myProfileNameLabel)
        
        myProfileImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11)
            $0.leading.equalToSuperview().offset(23)
            $0.width.height.equalTo(63)
        }

        myProfileNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalTo(myProfileImage.snp.trailing).offset(10)
        }
    }
    func setInfoData(model: UserProfileDto) {
        guard let profileImage = stampNameImageDictionary[model.user.latestStamp] else { return }
        self.myProfileImage.image = profileImage
        self.myProfileNameLabel.text = model.user.nickname
    }
}
