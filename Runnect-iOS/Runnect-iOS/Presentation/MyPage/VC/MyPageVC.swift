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
    }
    
    private func setLayout() {
        
    }
}
