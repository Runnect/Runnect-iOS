//
//  LocationSelectView.swift
//  Runnect-iOS
//
//  Created by Sojin Lee on 2023/09/25.
//

import UIKit
import Then
import SnapKit

enum locationType {
    case current
    case map
    
    var icon: UIImage {
        switch self {
        case .current:
            return ImageLiterals.icDirection
        case .map:
            return ImageLiterals.icSmallMap
        }
    }
    
    var text: String {
        switch self {
        case .current:
            return "현재 위치에서 시작하기"
        case .map:
            return "지도에서 선택하기"
        }
    }
    
    var width: Int {
        switch self {
        case .current:
            return 167
        case .map:
            return 138
        }
    }
}

class LocationSelectView: BaseView {
    let type: locationType
    
    private lazy var view = UIView()
    private lazy var icon = UIImageView().then {
        $0.image = type.icon
    }
    
    private lazy var label = UILabel().then {
        $0.text = type.text
        $0.font = .h5
        $0.textColor = .g3
        $0.sizeToFit()
    }
    
    init(type: locationType) {
        self.type = type
        
        super.init(frame: .zero)
    }
    
    override func setLayout() {
        super.setLayout()
        
        view.addSubviews(icon, label)
        addSubviews(view)
        
        icon.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.leading.equalTo(icon.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
        }
        
        view.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(type.width)
        }
    }
}
