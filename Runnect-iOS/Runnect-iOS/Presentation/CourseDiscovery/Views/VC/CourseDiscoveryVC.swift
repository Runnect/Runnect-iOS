//
//  CourseDiscoveryVC.swift
//  Runnect-iOS
//
//  Created by 이명진 on 2023/11/21.
//

import UIKit
import Then
import SnapKit
import Combine
import Moya

protocol ScrapStateDelegate: AnyObject {
    func didUpdateScrapState(publicCourseId: Int, isScrapped: Bool)
    func didRemoveCourse(publicCourseId: Int)
    // 코스 상세 에서 스크랩 누르면 코스발견에 해당 부분 스크랩 누르는 이벤트 전달
}

final class CourseDiscoveryVC: UIViewController {
    
    // MARK: - Properties
    
    private let publicCourseProvider = Providers.publicCourseProvider
    private let scrapProvider = Providers.scrapProvider
    private let serverResponseNumber = 10
    
    private var courseList = [PublicCourse]()
    private var cancelBag = CancelBag()
    private var specialList = [String]()
    private var totalPageNum = 0
    private var isEnd: Bool = false
    private var pageNo: Int = 1
    private var sort = "date"
    private var isDataLoaded = false
    
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
    
    private let miniUploadButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.icPlusButton, for: .normal)
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
        setLayout()
        setAddTarget()
        setCombineEvent()
        self.getCourseData(pageNo: pageNo)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideTabBar(wantsToHide: false)
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
        let cellTypes: [UICollectionViewCell.Type] = [AdImageCollectionViewCell.self,
                                                      MarathonTitleCollectionViewCell.self,
                                                      MarathonMapCollectionViewCell.self,
                                                      TitleCollectionViewCell.self,
                                                      CourseListCVC.self]
        cellTypes.forEach { cellType in
            mapCollectionView.register(cellType, forCellWithReuseIdentifier: cellType.className)
        }
    }
    
    private func setAddTarget() {
        self.searchButton.addTarget(self, action: #selector(pushToSearchVC), for: .touchUpInside)
        self.uploadButton.addTarget(self, action: #selector(pushToDiscoveryVC), for: .touchUpInside)
        self.miniUploadButton.addTarget(self, action: #selector(pushToDiscoveryVC), for: .touchUpInside)
    }
    
    private func setCombineEvent() {
        CourseSelectionPublisher.shared.didSelectCourse
            .sink { [weak self] indexPath in
                self?.setMarathonCourseSelection(at: indexPath)
            }
            .store(in: cancelBag)
    }
    
    private func reloadCellForCourse(publicCourseId: Int) {
        if let index = courseList.firstIndex(where: { $0.id == publicCourseId }) {
            let indexPath = IndexPath(item: index, section: Section.courseList)
            mapCollectionView.reloadItems(at: [indexPath])
            print("\(indexPath) 부분 스크랩 교체 되었음")
        }
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
        self.miniUploadButton.alpha = 0.0 /// 이거 없으면 처음에 UIView.animate 효과 보임
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
    
    private func setLayout() {
        view.addSubviews(mapCollectionView, uploadButton, miniUploadButton)
        view.bringSubviewToFront(uploadButton)
        view.bringSubviewToFront(miniUploadButton)
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
        
        miniUploadButton.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(276)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            make.width.height.equalTo(41)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(300)
            make.centerX.equalTo(naviBar)
        }
        
        self.view.bringSubviewToFront(uploadButton)
        self.view.bringSubviewToFront(miniUploadButton)
        
    }
}

// MARK: - Constants

extension CourseDiscoveryVC {
    private enum Section {
        static let adImage = 0 // 광고 이미지
        static let marathonTitle = 1 // 마라톤 코스 설명
        static let recommendedList = 2 // 마라톤 코스
        static let title = 3 // 추천 코스 설명
        static let courseList = 4 // 추천 코스
    }
    
    private enum Layout {
        static let cellSpacing: CGFloat = 20
        static let interitemSpacing: CGFloat = 10
        static let sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CourseDiscoveryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Section.adImage, Section.marathonTitle, Section.recommendedList, Section.title:
            return 1
        case Section.courseList:
            return self.courseList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Section.adImage:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdImageCollectionViewCell.className, for: indexPath) as? AdImageCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case Section.marathonTitle:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarathonTitleCollectionViewCell.className, for: indexPath) as? MarathonTitleCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case Section.recommendedList:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarathonMapCollectionViewCell.className, for: indexPath) as? MarathonMapCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case Section.title:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.className, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
            cell.delegate = self
            return cell
        case Section.courseList:
            return courseListCell(collectionView: collectionView, indexPath: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    private func courseListCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseListCVC.className, for: indexPath) as? CourseListCVC else { return UICollectionViewCell() }
        cell.setCellType(type: .all)
        cell.delegate = self
        let model = self.courseList[indexPath.item]
        let location = "\(model.departure.region) \(model.departure.city)"
        cell.setData(imageURL: model.image, title: model.title, location: location, didLike: model.scrap, indexPath: indexPath.item)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CourseDiscoveryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        
        switch indexPath.section {
        case Section.adImage:
            return CGSize(width: screenWidth, height: screenWidth * (174/390))
        case Section.marathonTitle:
            return CGSize(width: screenWidth, height: 98)
        case Section.recommendedList:
            return CGSize(width: screenWidth, height: 194)
        case Section.title:
            return CGSize(width: screenWidth, height: 106)
        case Section.courseList:
            let cellWidth = (screenWidth - 42) / 2
            let cellHeight = CourseListCVCType.getCellHeight(type: .all, cellWidth: cellWidth)
            return CGSize(width: cellWidth, height: cellHeight)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    /// section 이 4일때만 정해진 레이아웃 리턴
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == Section.courseList ? Layout.cellSpacing : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return section == Section.courseList ? Layout.interitemSpacing : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == Section.courseList ? Layout.sectionInset : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == Section.courseList {
            let courseDetailVC = CourseDetailVC()
            courseDetailVC.delegate = self
            let courseModel = courseList[indexPath.item]
            courseDetailVC.setCourseId(courseId: courseModel.courseId, publicCourseId: courseModel.id)
            courseDetailVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(courseDetailVC, animated: true)
        }
    }
    
    // 외부에서 Marathon Cell에서 받아오는 indexPath를 처리 합니다.
    private func setMarathonCourseSelection(at indexPath: IndexPath) {
        if let marathonCell = mapCollectionView.cellForItem(at: IndexPath(item: 0, section: Section.recommendedList)) as? MarathonMapCollectionViewCell {
            let marathonCourseList = marathonCell.marathonCourseList
            let courseDetailVC = CourseDetailVC()
            let courseModel = marathonCourseList[indexPath.item]
            courseDetailVC.setCourseId(courseId: courseModel.courseId, publicCourseId: courseModel.id)
            courseDetailVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(courseDetailVC, animated: true)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension CourseDiscoveryVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        performPagination()
        changeButtonStyleOnScroll()
    }
    
    private func performPagination() {
        let contentOffsetY = mapCollectionView.contentOffset.y // 우리가 보는 화면
        let collectionViewHeight = mapCollectionView.contentSize.height // 전체 사이즈
        let paginationY = mapCollectionView.bounds.size.height // 유저 화면의 가장 아래 y축 이라고 생각
        
        /// 페이지네이션 중단 코드
        if contentOffsetY > collectionViewHeight - paginationY {
            if courseList.count < pageNo * serverResponseNumber {
                // 페이지 끝에 도달하면 현재 페이지에 더 이상 데이터가 없음을 의미
                // 새로온 데이터의 갯수가 원래 서버에서 응답에서 온 갯수보다 작으면 페이지네이션 금지
                return
            }
            
            if pageNo < totalPageNum {
                if !isDataLoaded {
                    isDataLoaded = true
                    print("🫠\(pageNo)")
                    self.pageNo += 1
                    getCourseData(pageNo: pageNo)
                    isDataLoaded = false
                }
            }
        }
    }
    
    private func changeButtonStyleOnScroll() {
        let contentOffsetY = mapCollectionView.contentOffset.y
        let scrollThreshold = mapCollectionView.bounds.size.height * 0.1 // 10% 스크롤 했으면 UI 변경
        
        UIView.animate(withDuration: 0.25) {
            if contentOffsetY > scrollThreshold {
                // 10% 이상 스크롤 했을 때
                self.downScroll()
            } else {
                self.upScroll()
            }
        }
    }
    
    private func downScroll() {
        self.uploadButton.transform = CGAffineTransform(scaleX: 0.3, y: 0.96)
        self.miniUploadButton.frame.origin.x = 332 // 직접 피그마보고 상수 맞췄습니다.
        self.uploadButton.alpha = 0.0
        self.miniUploadButton.alpha = 1.0
    }
    
    private func upScroll() {
        self.uploadButton.transform = .identity
        self.miniUploadButton.alpha = 0.0
        self.uploadButton.alpha = 1.0
        self.miniUploadButton.frame.origin.x = 276
    }
}

// MARK: - CourseListCVCDelegate

extension CourseDiscoveryVC: CourseListCVCDeleagte {
    func likeButtonTapped(wantsTolike: Bool, index: Int) {
        guard UserManager.shared.userType != .visitor else {
            showToastOnWindow(text: "러넥트에 가입하면 코스를 스크랩할 수 있어요")
            return
        }
        
        let publicCourseId = courseList[index].id
        self.scrapCourse(publicCourseId: publicCourseId, scrapTF: wantsTolike)
    }
}

// MARK: - CourseDetailVCDelegate

extension CourseDiscoveryVC: ScrapStateDelegate {
    func didUpdateScrapState(publicCourseId: Int, isScrapped: Bool) {
        // CourseDetail에서 id와 scrap정보를 받아와 여기서 처리
        if let index = courseList.firstIndex(where: { $0.id == publicCourseId }) {
            courseList[index].scrap = isScrapped
            reloadCellForCourse(publicCourseId: publicCourseId)
            print("‼️CourseDiscoveryVC 델리게이트 받음 index=\(index)")
        }
    }
    
    func didRemoveCourse(publicCourseId: Int) {
        if let index = courseList.firstIndex(where: { $0.id == publicCourseId }) {
            self.courseList.remove(at: index)
            self.mapCollectionView.reloadData()
            print("didRemoveCourse= 삭제되었음\n")
        }
    }
}

// MARK: - Network

extension CourseDiscoveryVC {
    private func getCourseData(pageNo: Int) {
        LoadingIndicator.showLoading() // 항상 0.7초 늦게 로딩이 되어 버림 0.5초를 넣은 이유는 pagination을 구현할때 한번에 다 받아오지 않게 하기 위함
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [self] in
            publicCourseProvider.request(.getCourseData(pageNo: pageNo, sort: sort)) { response in
                LoadingIndicator.hideLoading()
                print("‼️ sort=  \(self.sort) ‼️\n")
                switch response {
                case .success(let result):
                    let status = result.statusCode
                    if 200..<300 ~= status {
                        do {
                            let responseDto = try result.map(BaseResponse<PickedMapListResponseDto>.self)
                            guard let data = responseDto.data else { return }
                            self.totalPageNum = data.totalPageSize
                            self.isEnd = data.isEnd
                            self.courseList.append(contentsOf: data.publicCourses)
                            self.mapCollectionView.reloadData()
                            print("pageNo= \(pageNo), isEnd= \(self.isEnd), totalPageNum= \(self.totalPageNum)")
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
    
    private func getTotalPageNum() {
        LoadingIndicator.showLoading()
        publicCourseProvider.request(.getTotalPageCount) { response in
            LoadingIndicator.hideLoading()
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<TotalPageCountDto>.self)
                        guard let data = responseDto.data else { return }
                        self.totalPageNum = data.totalPageCount
                        print("추천 코스의 코스의 수는 \(self.totalPageNum) 입니다. 🏃‍♀️\n")
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

extension CourseDiscoveryVC: TitleCollectionViewCellDelegate {
    func didTapSortButton(ordering: String) {
        // 기존의 getCourseData 함수 호출을 getSortedCourseData로 변경
        pageNo = 1
        print("‼️\(ordering)‼️ 터치 하셨습니다. 0.7초 후에 ‼️\(ordering)‼️ 으로 정렬이 되는 데이터가 불러 옵니다.")
        sort = ordering
        self.courseList.removeAll()
        getCourseData(pageNo: pageNo)
    }
}
