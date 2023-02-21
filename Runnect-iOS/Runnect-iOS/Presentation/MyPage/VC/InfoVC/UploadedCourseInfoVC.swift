//
//  UploadedCourseInfoVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/02.
//

import UIKit

import SnapKit
import Then
import Moya

final class UploadedCourseInfoVC: UIViewController {
    
    // MARK: - Properties
    
    private var uploadedCourseProvider = MoyaProvider<PublicCourseRouter>(
        plugins: [NetworkLoggerPlugin(verbose: true)]
    )
    
    private var uploadedCourseList = [PublicCourse]()
    
    // MARK: - Constants
    
    final let uploadedCourseInset: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 25, right: 16)
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
        
        return collectionView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
        register()
        setDelegate()
        getUploadedCourseInfo()
    }
}

// MARK: - Methods

extension UploadedCourseInfoVC {
    private func setData(courseList: [PublicCourse]) {
        self.uploadedCourseList = courseList
        UploadedCourseInfoCollectionView.reloadData()
    }
    
    private func setDelegate() {
        self.UploadedCourseInfoCollectionView.delegate = self
        self.UploadedCourseInfoCollectionView.dataSource = self
    }
    
    private func register() {
        UploadedCourseInfoCollectionView.register(UploadedCourseInfoCVC.self,
                                     forCellWithReuseIdentifier: UploadedCourseInfoCVC.className)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UploadedCourseInfoVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let doubleCellWidth = screenWidth - uploadedCourseInset.left - uploadedCourseInset.right - uploadedCourseItemSpacing
        let cellHeight = (doubleCellWidth / 2) * 0.7 + 36
        return CGSize(width: doubleCellWidth / 2, height: cellHeight)
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
        return uploadedCourseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let uploadedCourseCell = collectionView.dequeueReusableCell(withReuseIdentifier: UploadedCourseInfoCVC.className, for: indexPath) as? UploadedCourseInfoCVC else { return UICollectionViewCell()}
        uploadedCourseCell.setData(model: uploadedCourseList[indexPath.item])
        return uploadedCourseCell
    }
}

// MARK: - Network

extension UploadedCourseInfoVC {
    func getUploadedCourseInfo() {
        LoadingIndicator.showLoading()
        uploadedCourseProvider.request(.getUploadedCourseInfo) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<PickedMapListResponseDto>.self)
                        guard let data = responseDto.data else { return }
                        self.setData(courseList: data.publicCourses)
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
