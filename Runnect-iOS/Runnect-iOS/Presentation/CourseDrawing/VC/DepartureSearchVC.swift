//
//  DepartureSearchVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/02.
//

import UIKit

import Combine
import Moya
import CoreLocation

/// 현재 위치 | 검색 | 지도에서 선택 중 분기처리를 해주기 위함
enum SelectedType {
    case other
    case map
}

final class DepartureSearchVC: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    private let departureSearchingProvider = Providers.departureSearchingProvider
    
    private var addressList = [KakaoAddressResult]()
    private var cancelBag = CancelBag()
    private var locationManager = CLLocationManager()
    private var selectedType: SelectedType = .other
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .search)
        .setTextFieldPlaceholder(placeholder: "출발지를 설정해주세요")
        .showKeyboard()
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .g5
    }
    
    private let selectDirectionView = LocationSelectView(type: .current)
    private let selectMapView = LocationSelectView(type: .map)
    
    private lazy var locationSelectStackView = UIStackView().then {
        $0.addArrangedSubview(selectDirectionView)
        $0.addArrangedSubview(selectMapView)
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .center
    }
    
    private let thinDividerView = UIView().then {
        $0.backgroundColor = .g5
    }
    
    private let locationTableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
    }
    
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
    
    // MARK: - View Life Cycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setDelegate()
        self.registerCell()
        self.setBinding()
    }
}

// MARK: - Methods

extension DepartureSearchVC {
    private func setDelegate() {
        self.naviBar.delegate = self
        self.locationTableView.delegate = self
        self.locationTableView.dataSource = self
    }
    
    private func registerCell() {
        self.locationTableView.register(LocationSearchResultTVC.self,
                                        forCellReuseIdentifier: LocationSearchResultTVC.className)
    }
    
    func setData(data: [KakaoAddressResult]) {
        self.addressList = data
        emptyDataView.isHidden = !data.isEmpty
        locationTableView.reloadData()
    }
    
    private func setBinding() {
        selectDirectionView.gesture().sink { _ in
            self.selectedType = .other
            self.setLocation()
        }.store(in: cancelBag)
        
        selectMapView.gesture().sink { _ in
            self.selectedType = .map
            self.setLocation()
        }.store(in: cancelBag)
    }
    
}

// MARK: - Location
extension DepartureSearchVC {
    /// 현재 위도, 경도에 따른 주소 받아오는 함수
    private func setLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        DispatchQueue.global().async { [self] in
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
                
                guard let latitude = locationManager.location?.coordinate.latitude,
                      let longitude = locationManager.location?.coordinate.longitude else { return }
                searchLocationTmapAddress(latitude: latitude, longitude: longitude)
            }
            else {
                locationManager.startUpdatingLocation()
            }
        }
    }
}

// MARK: - UI & Layout

extension DepartureSearchVC {
    private func setUI() {
        view.backgroundColor = .w1
        emptyDataView.isHidden = true // 데이터가 없으면 false로 설정
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, dividerView, locationSelectStackView, thinDividerView, locationTableView)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(6)
        }
        
        locationSelectStackView.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(52)
        }
        
        selectDirectionView.snp.makeConstraints { make in
            make.height.equalTo(locationSelectStackView.snp.height)
            make.centerY.equalTo(locationSelectStackView)
        }
        
        selectMapView.snp.makeConstraints { make in
            make.height.equalTo(locationSelectStackView.snp.height)
            make.centerY.equalTo(locationSelectStackView)
        }
        
        thinDividerView.snp.makeConstraints { make in
            make.top.equalTo(locationSelectStackView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        locationTableView.snp.makeConstraints { make in
            make.top.equalTo(thinDividerView.snp.bottom)
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        locationTableView.addSubview(emptyDataView)
        emptyDataView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DepartureSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationSearchResultTVC.className, for: indexPath)
                as? LocationSearchResultTVC
        else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setData(model: self.addressList[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let courseDrawingVC = CourseDrawingVC()
        
        let departureLocationModel = addressList[indexPath.item].toDepartureLocationModel()
        courseDrawingVC.setData(model: departureLocationModel)
        courseDrawingVC.selectedType = .other
        
        courseDrawingVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(courseDrawingVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.naviBar.hideKeyboard()
    }
}

// MARK: - CustomNavigationBarDelegate

extension DepartureSearchVC: CustomNavigationBarDelegate {
    func searchButtonDidTap(text: String) {
        searchAddressWithKeyword(keyword: text)
    }
}

// MARK: - Network

extension DepartureSearchVC {
    private func searchAddressWithKeyword(keyword: String) {
        LoadingIndicator.showLoading()
        departureSearchingProvider
            .request(.getAddress(keyword: keyword)) { [weak self] response in
            guard let self = self else { return }
            LoadingIndicator.hideLoading()
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(DepartureSearchingResponseDto.self)
                        self.setData(data: responseDto.documents)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                if status >= 400 {
                    print("400 error")
                    self.setData(data: [])
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showToast(message: "네트워크 통신 실패")
            }
        }
    }
    
    private func searchLocationTmapAddress(latitude: Double, longitude: Double) {
        departureSearchingProvider
            .request(.getLocationTmapAddress(latitude: latitude, longitude: longitude)) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let result):
                    let status = result.statusCode
                    if 200..<300 ~= status {
                        do {
                            let responseDto = try result.map(TmapAddressSearchingResponseDto.self)
                            let courseDrawingVC = CourseDrawingVC()
                            
                            courseDrawingVC.selectedType = self.selectedType
                            courseDrawingVC.setData(model: responseDto.toDepartureLocationModel(latitude: latitude, longitude: longitude))
                            
                            courseDrawingVC.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(courseDrawingVC, animated: true)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    if status >= 400 {
                        print("400 error")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.showToast(message: "네트워크 통신 실패")
                }
            }
    }
}
