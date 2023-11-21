//
//  RecommendedMapCollectionViewCell.swift
//  Runnect-iOS
//
//  Created by 이명진 on 11/18/23.
//

import UIKit
import SnapKit
import Then

class RecommendedMapCollectionViewCell: UICollectionViewCell {
    private let PublicCourseProvider = Providers.publicCourseProvider
    
    private lazy var recommendedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Constants
    
    final let collectionViewInset = UIEdgeInsets(top: 0, left: 16, bottom: 34, right: 16)
    final let itemSpacing: CGFloat = 10
    final let lineSpacing: CGFloat = 10
    private var courseList = [PublicCourse]()
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        register()
        setDelegate()
        getCourseData()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecommendedMapCollectionViewCell {
    
    private func setDelegate() {
        recommendedCollectionView.delegate = self
        recommendedCollectionView.dataSource = self
    }
    private func register() {
        recommendedCollectionView.register(CourseListCVC.self,
                                           forCellWithReuseIdentifier: CourseListCVC.className)
    }
}
// MARK: - Extensions

extension RecommendedMapCollectionViewCell {
    
    // MARK: - Layout Helpers
    
    func layout() {
        contentView.backgroundColor = .clear
        contentView.addSubview(recommendedCollectionView)
        recommendedCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(contentView.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setData(courseList: [PublicCourse]) {
        self.courseList = courseList
        recommendedCollectionView.reloadData()
    }
    
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension RecommendedMapCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseListCVC.className,
                                                            for: indexPath)
                as? CourseListCVC else { return UICollectionViewCell() }
        cell.setCellType(type: .all)
        let model = self.courseList[indexPath.item]
        let location = "\(model.departure.region) \(model.departure.city)"
        cell.setData(imageURL: model.image, title: model.title, location: location, didLike: model.scrap, indexPath: indexPath.item)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RecommendedMapCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 156, height: 160)
    } // 셀사이즈 RecommendedCVC와  연결 되면 변경
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.collectionViewInset
    }
    
    // 이게 반대방향
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.itemSpacing
    }
    
    // 이게 스크롤방향
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.lineSpacing
    }
    
}

// 원래 서버에서 1페이지만 가져온 데이터로 테스트

extension RecommendedMapCollectionViewCell {
    private func getCourseData() {
        LoadingIndicator.showLoading()
        PublicCourseProvider.request(.getCourseData(pageNo: 1)) { response in
            LoadingIndicator.hideLoading()
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<PickedMapListResponseDto>.self)
                        guard let data = responseDto.data else { return }
                        
                        // 새로 받은 데이터를 기존 리스트에 추가 (쌓기 위함)
                        self.courseList.append(contentsOf: data.publicCourses)
                        
                        // UI를 업데이트하여 추가된 데이터를 반영합니다.
                        self.setData(courseList: self.courseList)
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                if status >= 400 {
                    print("400 error")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
