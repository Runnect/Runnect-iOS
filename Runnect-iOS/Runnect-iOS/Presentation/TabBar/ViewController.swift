//
//  ViewController.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import UIKit

class ViewController: UIViewController {

    let sampleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.imgLogo
        return imageView
    }()
    
    let sampleLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트 라벨입니다."
        label.font = UIFont.h1
        label.textColor = UIColor.g2
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.m1
        view.addSubviews(sampleImageView, sampleLabel)
        
        sampleImageView.snp.makeConstraints { make in
            make.leading.top.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
        
        sampleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
