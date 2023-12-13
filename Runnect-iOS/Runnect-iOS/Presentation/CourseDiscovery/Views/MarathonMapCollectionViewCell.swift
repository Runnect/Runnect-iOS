//
//  MarathonMapCollectionViewCell.swift
//  Runnect-iOS
//
//  Created by 이명진 on 11/18/23.
//

import UIKit
import Combine

class CourseSelectionPublisher {
    static let shared = CourseSelectionPublisher()
    
    private init() {}
    
    let didSelectCourse = PassthroughSubject<IndexPath, Never>()
}

final class MarathonMapCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    private let PublicCourseProvider = Providers.publicCourseProvider
    var marathonCourseList = [marathonCourse]() // Cell 사용하는 곳에서 사용 중이라 private ❌
    
    // MARK: - UIComponents
    
    private lazy var marathonCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Constants
    
    private let collectionViewInset = UIEdgeInsets(top: 0, left: 16, bottom: 34, right: 16)
    private let itemSpacing: CGFloat = 10
    private let lineSpacing: CGFloat = 10
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        register()
        setDelegate()
        getMarathonCourseData()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Method

extension MarathonMapCollectionViewCell {
    private func setDelegate() {
        marathonCollectionView.delegate = self
        marathonCollectionView.dataSource = self
    }
    
    private func register() {
        marathonCollectionView.register(CourseListCVC.self,
                                        forCellWithReuseIdentifier: CourseListCVC.className)
    }
}

// MARK: - Layout Helpers

extension MarathonMapCollectionViewCell {
    private func setLayout() {
        contentView.backgroundColor = .clear
        contentView.addSubview(marathonCollectionView)
        
        marathonCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(contentView.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setData(marathonCourseList: [marathonCourse]) {
        self.marathonCourseList = marathonCourseList
        marathonCollectionView.reloadData()
    }
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MarathonMapCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return marathonCourseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseListCVC.className,
                                                            for: indexPath)
                as? CourseListCVC else { return UICollectionViewCell() }
        cell.setCellType(type: .all)
        let model = self.marathonCourseList[indexPath.item]
        let location = "\(model.departure.region) \(model.departure.city)"
        cell.setData(imageURL: model.image, title: model.title, location: location, didLike: model.scrap, indexPath: indexPath.item)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MarathonMapCollectionViewCell: UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CourseSelectionPublisher.shared.didSelectCourse.send(indexPath)
        // 코스 발견에 이벤트 전달
    }
    
}

// MARK: - NetWork

extension MarathonMapCollectionViewCell {
    private func getMarathonCourseData() {
        LoadingIndicator.showLoading()
        PublicCourseProvider.request(.getMarathonCourseData) { response in
            LoadingIndicator.hideLoading()
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<MarathonListResponseDto>.self)
                        guard let data = responseDto.data else { return }
                        self.setData(marathonCourseList: data.marathonPublicCourses)
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
