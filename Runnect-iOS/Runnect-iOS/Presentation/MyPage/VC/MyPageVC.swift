//
//  MyPageVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit
import SnapKit
import Then

final class MyPageVC: UIViewController, CustomNavigationBarDelegate {
    
    private lazy var navibar = CustomNavigationBar(self, type: .title).setTitle("마이페이지")
    private let myProfileView = UIView()
    private let myProfileImage = UIImageView().then {
        $0.image = ImageLiterals.imgStampR2
    }
    private let myProfileNameLabel = UILabel().then {
        $0.text = "말랑콩떡"
        $0.textColor = .m1
        $0.font = .h4
    }
    private let myProfileEditButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icEdit, for: .normal)
        $0.setTitle("수정하기", for: .normal)
        $0.titleLabel?.font = .b7
        $0.setTitleColor(.m2, for: .normal)
        $0.tintColor = .m2
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.m2.cgColor
        $0.layer.cornerRadius = 15
        $0.configuration?.imagePadding = 3
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
    }
    
    func searchButtonDidTap(text: String) {
        print(text)
    }
}

extension MyPageVC {
    
    private func setNavigationBar() {
        navibar.delegate = self
        
        view.addSubview(navibar)
        
        navibar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
    }
    
    private func setUI() {
        view.backgroundColor = .white
        myProfileView.backgroundColor = .m3
    }
    
    private func setLayout() {
        view.addSubviews(myProfileView)
        
        myProfileView.snp.makeConstraints { make in
            make.top.equalTo(navibar.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(84)
        }
        
        myProfileView.addSubviews(myProfileImage, myProfileNameLabel, myProfileEditButton)
        
        myProfileImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.leading.equalToSuperview().offset(23)
            make.width.equalTo(63)
            make.height.equalTo(63)
        }
        
        myProfileNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalTo(myProfileImage.snp.trailing).offset(10)
        }
        
        myProfileEditButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(78)
            make.height.equalTo(28)
        }

    }
}
