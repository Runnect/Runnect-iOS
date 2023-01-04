//
//  UploadedCourseInfoVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/02.
//

import UIKit
import SnapKit
import Then

final class UploadedCourseInfoVC: UIViewController {
    
    // MARK: - Properties
    
    var UploadedCourseList: [UploadedCourseInfoModel] = [
        UploadedCourseInfoModel(title: "행복한 날들", place: "수원시 장안구"),
        UploadedCourseInfoModel(title: "몽이랑 산책", place: "수원시 장안구"),
        UploadedCourseInfoModel(title: "패스트파이브", place: "수원시 장안구"),
        UploadedCourseInfoModel(title: "행복한 날들", place: "수원시 장안구"),
        UploadedCourseInfoModel(title: "몽이랑 산책", place: "수원시 장안구"),
        UploadedCourseInfoModel(title: "패스트파이브", place: "수원시 장안구"),
        UploadedCourseInfoModel(title: "행복한 날들", place: "수원시 장안구"),
        UploadedCourseInfoModel(title: "몽이랑 산책", place: "수원시 장안구"),
        UploadedCourseInfoModel(title: "패스트파이브", place: "수원시 장안구")
    ]
    
    // MARK: - Constants
    
    final let uploadedCourseInset: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    final let uploadedCourseLineSpacing: CGFloat = 20
    final let uploadedCourseItemSpacing: CGFloat = 10
    final let uplodaedCourseCellHeight: CGFloat = 124

    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton).setTitle("업로드한 코스")
    
    private lazy var UploadedCourseInfoCollectionView: UICollectionView = {
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

extension UploadedCourseInfoVC {
    
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
        UploadedCourseInfoCollectionView.backgroundColor = .w1
    }
    
    private func setLayout() {
        view.addSubview(UploadedCourseInfoCollectionView)
        
        UploadedCourseInfoCollectionView.snp.makeConstraints {  make in
            make.top.equalTo(navibar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - General Helpers

    private func register() {
        UploadedCourseInfoCollectionView.register(UploadedCourseInfoCVC.self,
                                     forCellWithReuseIdentifier: UploadedCourseInfoCVC.className)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UploadedCourseInfoVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let doubleCellWidth = screenWidth - uploadedCourseInset.left - uploadedCourseInset.right - uploadedCourseItemSpacing
        return CGSize(width: doubleCellWidth / 2, height: 164)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return uploadedCourseLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return uploadedCourseInset
    }
}

// MARK: - UICollectionViewDataSource

extension UploadedCourseInfoVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UploadedCourseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let uploadedCourseCell = collectionView.dequeueReusableCell(withReuseIdentifier: UploadedCourseInfoCVC.className, for: indexPath) as? UploadedCourseInfoCVC else { return UICollectionViewCell()}
        uploadedCourseCell.dataBind(model: UploadedCourseList[indexPath.item])
        return uploadedCourseCell
    }
}
