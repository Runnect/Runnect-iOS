//
//  CountDownVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/03.
//

import UIKit
import NMapsMap

final class CountDownVC: UIViewController {
    
    // MARK: - Properties
    
    private var count = 3
    var locations = [NMGLatLng]()
    
    // MARK: - UI Components
    
    private let backgroundImageView = UIImageView().then {
        $0.image = ImageLiterals.imgBackground
        $0.contentMode = .scaleAspectFill
    }
    
    private let timeLabel = UILabel().then {
        $0.text = "3"
        $0.font = .h6
        $0.textColor = .w1
    }
    
    private let directionLabel = UILabel().then {
        $0.text = "잠시 후 러닝을 시작합니다"
        $0.font = .b1
        $0.textColor = .w1
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        animateTimeLabel()
    }
}

// MARK: - Methods

extension CountDownVC {
    private func animateTimeLabel() {
        self.timeLabel.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        self.timeLabel.text = "\(self.count)"
        UIView.animate(withDuration: 1.0, animations: {
            self.timeLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { _ in
            self.count -= 1
            if self.count > 0 {
                self.animateTimeLabel()
            } else {
                let runTrackingVC = RunTrackingVC()
                runTrackingVC.makePath(locations: self.locations)
                self.navigationController?.pushViewController(runTrackingVC, animated: true)
                
                // CountDownVC를 navigationController 스택에서 제거하여 pop 하였을 때 더 이전 뷰로 넘어가지도록 함
                self.navigationController?.viewControllers.removeAll { vc in
                    vc.isKind(of: CountDownVC.self)
                }
            }
        })
    }
}

// MARK: - UI & Layout

extension CountDownVC {
    private func setUI() {
        view.backgroundColor = .m1
    }
    
    private func setLayout() {
        view.addSubviews(backgroundImageView, timeLabel, directionLabel)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.9)
        }
        
        directionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide).multipliedBy(1.15)
        }
    }
}
