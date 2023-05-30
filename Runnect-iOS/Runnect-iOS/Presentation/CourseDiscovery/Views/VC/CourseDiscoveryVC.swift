//
//  CourseDiscoveryVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit

import Then
import SnapKit
import Combine
import Moya

final class CourseDiscoveryVC: UIViewController {
    // MARK: - Properties
    
    private let PublicCourseProvider = Providers.publicCourseProvider
    
    private let scrapProvider = Providers.scrapProvider
    
    private var courseList = [PublicCourse]()
    
    // MARK: - UIComponents
    
    private lazy var naviBar = CustomNavigationBar(self, type: .title).setTitle("코스 발견")
    private let searchButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icSearch, for: .normal)
        $0.tintColor = .g1
    }
    private let uploadButton = CustomButton(title: "업로드").then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.setImage(ImageLiterals.icPlus, for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    private let emptyView = ListEmptyView(description: "공유할 수 있는 코스가 없어요!\n코스를 그려주세요",
                                          buttonTitle: "코스 그리기")
    
    // MARK: - collectionview
    
    private lazy var mapCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad () {
        super.viewDidLoad()
        setUI()
        register()
        setNavigationBar()
        setDelegate()
        layout()
        setAddTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideTabBar(wantsToHide: false)
        self.getCourseData()
    }
}

// MARK: - Methods

extension CourseDiscoveryVC {
    
    private func setData(courseList: [PublicCourse]) {
        self.courseList = courseList
        mapCollectionView.reloadData()
        self.emptyView.isHidden = !courseList.isEmpty
    }
    
    private func setDelegate() {
        mapCollectionView.delegate = self
        mapCollectionView.dataSource = self
        emptyView.delegate = self
    }
    
    private func register() {
        self.mapCollectionView.register(AdImageCollectionViewCell.self, forCellWithReuseIdentifier: AdImageCollectionViewCell.className)
        self.mapCollectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.className)
        self.mapCollectionView.register(CourseListCVC.self, forCellWithReuseIdentifier: CourseListCVC.className)
    }
    
    private func setAddTarget() {
        self.searchButton.addTarget(self, action: #selector(pushToSearchVC), for: .touchUpInside)
        self.uploadButton.addTarget(self, action: #selector(pushToDiscoveryVC), for: .touchUpInside)
    }
}

// MARK: - @objc Function

extension CourseDiscoveryVC {
    @objc private func pushToSearchVC() {
        let nextVC = CourseSearchVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func pushToDiscoveryVC() {
        guard UserManager.shared.userType != .visitor else {
            self.showToastOnWindow(text: "러넥트에 가입하면 코스를 업로드할 수 있어요.")
            return
        }
        
        let nextVC = MyCourseSelectVC()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - UI & Layout

extension CourseDiscoveryVC {
    private func setUI() {
        view.backgroundColor = .w1
        mapCollectionView.backgroundColor = .w1
        self.emptyView.isHidden = true
    }
    
    private func setNavigationBar() {
        view.addSubview(naviBar)
        view.addSubview(searchButton)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        searchButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(naviBar)
        }
    }
    
    private func layout() {
        view.addSubviews(uploadButton, mapCollectionView)
        view.bringSubviewToFront(uploadButton)
        mapCollectionView.addSubview(emptyView)
        
        mapCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.naviBar.snp.bottom)
            $0.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        uploadButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
            make.width.equalTo(92)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(300)
            make.centerX.equalTo(naviBar)
        }
        
        let shadowView = ShadowView()
        self.view.addSubview(shadowView)

        shadowView.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
            make.width.equalTo(92)
        }
        
        self.view.bringSubviewToFront(uploadButton)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CourseDiscoveryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
        case 2:
            return self.courseList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdImageCollectionViewCell.className, for: indexPath) as? AdImageCollectionViewCell else { return UICollectionViewCell() }
            return cell
        } else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.className, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseListCVC.className, for: indexPath) as? CourseListCVC else { return UICollectionViewCell() }
            cell.setCellType(type: .all)
            cell.delegate = self
            let model = self.courseList[indexPath.item]
            let location = "\(model.departure.region) \(model.departure.city)"
            cell.setData(imageURL: model.image, title: model.title, location: location, didLike: model.scrap, indexPath: indexPath.item)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CourseDiscoveryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        _ = UICollectionViewCell()
        
        let screenWidth = UIScreen.main.bounds.width
        
        switch indexPath.section {
        case 0:
            return CGSize(width: screenWidth, height: screenWidth * (183/390))
        case 1:
            return CGSize(width: screenWidth, height: 80)
        case 2:
            let cellWidth = (screenWidth - 42) / 2
            let cellHeight = CourseListCVCType.getCellHeight(type: .all, cellWidth: cellWidth)
            return CGSize(width: cellWidth, height: cellHeight)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 2 {
            return 20
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 2 {
            return 10
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 2 {
            return UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let courseDetailVC = CourseDetailVC()
            let courseModel = courseList[indexPath.item]
            courseDetailVC.setCourseId(courseId: courseModel.courseId, publicCourseId: courseModel.id)
            courseDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(courseDetailVC, animated: true)
        }
    }
}

// MARK: - CourseListCVCDeleagte

extension CourseDiscoveryVC: CourseListCVCDeleagte {
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

extension CourseDiscoveryVC {
    private func getCourseData() {
        LoadingIndicator.showLoading()
        PublicCourseProvider.request(.getCourseData) { response in
            LoadingIndicator.hideLoading()
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
    
    private func scrapCourse(publicCourseId: Int, scrapTF: Bool) {
        LoadingIndicator.showLoading()
        scrapProvider.request(.createAndDeleteScrap(publicCourseId: publicCourseId, scrapTF: scrapTF)) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    print("스크랩 성공")
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

// MARK: - Section Heading

extension CourseDiscoveryVC: ListEmptyViewDelegate {
    func emptyViewButtonTapped() {
        self.tabBarController?.selectedIndex = 0
    }
}
