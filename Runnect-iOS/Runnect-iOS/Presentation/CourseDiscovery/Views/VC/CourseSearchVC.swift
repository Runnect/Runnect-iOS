//
//  SearchVC.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/05.
//

import UIKit

import Then
import SnapKit
import Moya

final class CourseSearchVC: UIViewController {
    
    // MARK: - Properties
    
    private let PublicCourseRouter = Providers.publicCourseProvider
    
    private let scrapProvider = Providers.scrapProvider
    
    private var courseList = [PublicCourse]()
    private var keyword: String?
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .search).setTextFieldPlaceholder(placeholder: "지역과 키워드 위주로 검색해보세요").showKeyboard()
    private let dividerView = UIView().then {
        $0.backgroundColor = .g5
    }
    
    private lazy var mapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let alertImageView = UIImageView().then {
        $0.image = ImageLiterals.icAlert
        $0.tintColor = .g3
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "검색결과가 없습니다\n검색어를 다시 확인해주세요"
        $0.font = .b4
        $0.textColor = .g3
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private lazy var emptyDataView = UIStackView(arrangedSubviews: [alertImageView, descriptionLabel]).then {
        $0.axis = .vertical
        $0.spacing = 22
        $0.alignment = .center
    }
    
    // MARK: - Constants
    
    final let collectionViewInset = UIEdgeInsets(top: 28, left: 16, bottom: 28, right: 16)
    final let itemSpacing: CGFloat = 10
    final let lineSpacing: CGFloat = 20
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
        setNavigationBar()
        setDelegate()
        layout()
        setTabBar()
        analyze(screenName: GAEvent.View.viewCourseSearch)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let keyword = self.keyword else { return }
        searchCourseWithKeyword(keyword: keyword)
    }
}
// MARK: - Methods

extension CourseSearchVC {
    
    private func setDelegate() {
        self.naviBar.delegate = self
        self.mapCollectionView.delegate = self
        self.mapCollectionView.dataSource = self
    }
    private func register() {
        mapCollectionView.register(CourseListCVC.self,
                                   forCellWithReuseIdentifier: CourseListCVC.className)
        
    }
    private func setTabBar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    private func setData(data: [PublicCourse]) {
        self.courseList = data
        self.emptyDataView.isHidden = !data.isEmpty
        mapCollectionView.reloadData()
    }
}

// MARK: - UI & Layout

extension CourseSearchVC {
    private func setNavigationBar() {
        view.addSubview(naviBar)
        naviBar.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
    }
    
    private func layout() {
        view.backgroundColor = .w1
        emptyDataView.isHidden = true // 데이터가 없으면 false로 설정
        view.addSubviews(dividerView, mapCollectionView)
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(6)
        }
        
        mapCollectionView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        mapCollectionView.addSubview(emptyDataView)
        
        emptyDataView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CourseSearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseListCVC.className,
                                                            for: indexPath)
                as? CourseListCVC else { return UICollectionViewCell() }
        cell.setCellType(type: .all)
        cell.delegate = self
        let model = self.courseList[indexPath.item]
        let location = "\(model.departure.region) \(model.departure.city)"
        cell.setData(imageURL: model.image, title: model.title, location: location, didLike: model.scrap, indexPath: indexPath.item)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let courseDetailVC = CourseDetailVC()
        let courseModel = courseList[indexPath.item]
        courseDetailVC.setCourseId(courseId: courseModel.courseId, publicCourseId: courseModel.id)
        courseDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(courseDetailVC, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CourseSearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (UIScreen.main.bounds.width - (self.itemSpacing + 2*self.collectionViewInset.left)) / 2
        let cellHeight = CourseListCVCType.getCellHeight(type: .all, cellWidth: cellWidth)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.collectionViewInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.lineSpacing
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.naviBar.hideKeyboard()
    }
}
// MARK: - CustomNavigationBarDelegate

extension CourseSearchVC: CustomNavigationBarDelegate {
    func searchButtonDidTap(text: String) {
        guard !text.isEmpty else { return }
        searchCourseWithKeyword(keyword: text)
        self.keyword = text
    }
}

// MARK: - CourseListCVCDelegate

extension CourseSearchVC: CourseListCVCDelegate {
    func likeButtonTapped(wantsTolike: Bool, index: Int) {
        guard UserManager.shared.userType != .visitor else {
            showToastOnWindow(text: "러넥트에 가입하면 코스를 스크랩할 수 있어요")
            return
        }
        
        let publicCourseId = courseList[index].id
        scrapCourse(publicCourseId: publicCourseId, scrapTF: wantsTolike)
    }
}

// MARK: - Network

extension CourseSearchVC {
    private func searchCourseWithKeyword(keyword: String) {
        LoadingIndicator.showLoading()
        PublicCourseRouter.request(.getCourseSearchData(keyword: keyword)) { response in
            LoadingIndicator.hideLoading()
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<PickedMapListResponseDto>.self)
                        guard let data = responseDto.data else { return }
                        self.analyze(buttonName: GAEvent.Button.clickTrySearchCourse)
                        self.setData(data: data.publicCourses)
                    } catch {
                        self.setData(data: [])
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
    
    private func scrapCourse(publicCourseId: Int, scrapTF: Bool) {
        LoadingIndicator.showLoading()
        scrapProvider.request(.createAndDeleteScrap(publicCourseId: publicCourseId, scrapTF: scrapTF)) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
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
