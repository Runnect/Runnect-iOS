//
//  RNMapView.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/02.
//
import UIKit
import CoreLocation
import Combine

import NMapsMap
import SnapKit
import Then

final class RNMapView: UIView {
    
    // MARK: - Properties
    
    @Published var pathDistance: Double = 0
    @Published var markerCount = 0
    
    var eventSubject = PassthroughSubject<Array<Double>, Never>()
    private var selectedType: SelectedType = .other
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    let pathImage = PassthroughSubject<UIImage?, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private let locationManager = CLLocationManager()
    private var isDrawMode: Bool = false
    private var markers = [RNMarker]() {
        didSet {
            markerCount = markers.count + 1
            self.makePath()
        }
    }
    /// startMarker를 포함한 모든 마커들의 위치 정보
    private var markersLatLngs: [NMGLatLng] {
        [self.startMarker.position] + self.markers.map { $0.position }
    }
    private var bottomPadding: CGFloat = 0
    private let locationOverlayIcon = NMFOverlayImage(image: ImageLiterals.icLocationOverlay)
    
    // MARK: - UI Components
    
    let map = NMFNaverMapView()
    private var startMarker = RNStartMarker()
    private let pathOverlay = NMFPath()
    private let locationButton = UIButton(type: .custom)
    
    // MARK: - initialization
    
    public init() {
        super.init(frame: .zero)
        self.mapInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.mapInit()
        setLocationOverlay()
    }
    
    private func mapInit() {
        setUI()
        setLayout()
        setDelegate()
        setMap()
        getLocationAuth()
        setPathOverlay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension RNMapView {
    /// isDrawMode (편집 모드) 설정
    @discardableResult
    func setDrawMode(to isDrawMode: Bool) -> Self {
        self.isDrawMode = isDrawMode
        return self
    }
    
    /// 카메라가 따라가는 mode 설정
    @discardableResult
    func setPositionMode(mode: NMFMyPositionMode) -> Self {
        map.mapView.positionMode = mode
        setLocationOverlay()
        return self
    }
    
    /// 지정 위치에 startMarker와 출발 infoWindow 생성 (기존의 startMarker는 제거)
    @discardableResult
    func makeStartMarker(at location: NMGLatLng, withCameraMove: Bool = false, type: SelectedType) -> Self {
        if type == .other {
            self.startMarker.position = location
        }
        
        self.startMarker.mapView = self.map.mapView
        self.startMarker.showInfoWindow()
        if withCameraMove {
            moveToLocation(location: location)
        }
        markerCount = 1
        return self
    }
    
    /// 사용자 위치에 startMarker와 출발 infoWindow 생성 (기존의 startMarker는 제거)
    @discardableResult
    func makeStartMarkerAtUserLocation(withCameraMove: Bool = false) -> Self {
        self.startMarker.position = getUserLocation()
        self.startMarker.mapView = self.map.mapView
        self.startMarker.showInfoWindow()
        moveToUserLocation()
        markerCount = 1
        return self
    }
    
    /// 지정 위치에 마커 생성
    @discardableResult
    func makeMarker(at location: NMGLatLng) -> Self {
        let marker = RNMarker()
        marker.position = location
        marker.mapView = self.map.mapView
        addDistance(with: location)
        self.markers.append(marker)
        return self
    }
    
    /// NMGLatLng 어레이를 받아서 모든 위치에 마커 생성
    @discardableResult
    func makeMarkers(at locations: [NMGLatLng]) -> Self {
        locations.forEach { location in
            makeMarker(at: location)
        }
        return self
    }
    
    /// NMGLatLng 어레이를 받아서 첫 위치를 startMarker로 설정하고 나머지를 일반 마커로 생성
    @discardableResult
    func makeMarkersWithStartMarker(at locations: [NMGLatLng], moveCameraToStartMarker: Bool) -> Self {
        removeMarkers()
        if locations.count < 2 { return self }
        makeStartMarker(at: locations[0], withCameraMove: moveCameraToStartMarker, type: .other)
        locations[1...].forEach { location in
            makeMarker(at: location)
        }
        return self
    }
    
    /// 캡처를 위한 좌표 설정 및 카메라 이동
    func makeCameraMoveForCapture(at locations: [NMGLatLng]) {
        map.mapView.contentInset = UIEdgeInsets(top: screenHeight/4, left: 0, bottom: screenHeight/4, right: 0)
        let bounds = makeMBR(at: locations)
        let cameraUpdate = NMFCameraUpdate(fit: bounds, padding: 100)
        cameraUpdate.animation = .none
        LoadingIndicator.showLoading()
        map.mapView.moveCamera(cameraUpdate) { isCancelled in
            if isCancelled {
                print("카메라 이동 취소")
                LoadingIndicator.hideLoading()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.makePathImage()
                    LoadingIndicator.hideLoading()
                }
            }
        }
    }
    
    /// 사용자 위치로 카메라 이동
    @discardableResult
    func moveToUserLocation() -> Self {
        let userLatLng = getUserLocation()
        let cameraUpdate = NMFCameraUpdate(scrollTo: userLatLng)
        
        DispatchQueue.main.async { [self] in
            cameraUpdate.animation = .easeIn
            self.map.mapView.moveCamera(cameraUpdate)
        }
        return self
    }
    
    /// 지정 위치로 카메라 이동
    @discardableResult
    func moveToLocation(location: NMGLatLng) -> Self {
        let cameraUpdate = NMFCameraUpdate(scrollTo: location)
        DispatchQueue.main.async { [self] in
            cameraUpdate.animation = .easeIn
            self.map.mapView.moveCamera(cameraUpdate)
        }
        return self
    }
    
    /// 저장된 위치들로 경로선 그리기
    @discardableResult
    func makePath() -> Self {
        if self.markersLatLngs.count == 1 {
            self.pathOverlay.mapView = nil
            return self
        }
        pathOverlay.path = NMGLineString(points: self.markersLatLngs)
        pathOverlay.mapView = map.mapView
        return self
    }
    
    /// locationButton 설정
    @discardableResult
    func showLocationButton(toShow: Bool) -> Self {
        self.locationButton.isHidden = !toShow
        return self
    }
    
    /// 지도에 ContentPadding을 지정하여 중심 위치가 변경되게 설정
    @discardableResult
    func makeContentPadding(padding: UIEdgeInsets) -> Self {
        map.mapView.contentInset = padding
        self.bottomPadding = padding.bottom
        updateSubviewsConstraints()
        return self
    }
    
    /// 네이버 지도 로고 Margin  설정
    @discardableResult
    func makeNaverLogoMargin(inset: UIEdgeInsets) -> Self {
        map.mapView.logoMargin = inset
        return self
    }
    
    /// 현재 존재하는 Marker들 위치 리턴
    func getMarkersLatLng() -> [NMGLatLng] {
        return self.markersLatLngs
    }
    
    /// 사용자 위치 가져오기
    func getUserLocation() -> NMGLatLng {
        let userLocation = locationManager.location?.coordinate
        let userLatLng = userLocation.toNMGLatLng()
        return userLatLng
    }
    
    /// 경로 총 거리 가져오기
    func getPathDistance() -> Double {
        return pathDistance
    }
    
    /// 더미 뷰를 UIImage로 변환하여 pathImage에 send
    func makePathImage() {
        if let image = UIImage.imageFromView(view: map.mapView) {
            guard let newImage = self.cropImage(inputImage: image) else {
                print("이미지 생성 실패")
                return
            }
            self.pathImage.send(newImage)
        }
    }
    
    /// 현재 시점까지의 마커들을 캡쳐하여 pahImage에 send
    func capturePathImage() {
        makeCameraMoveForCapture(at: self.markersLatLngs)
    }
    
    /// 바운더리(MBR) 생성
    func makeMBR(at locations: [NMGLatLng]) -> NMGLatLngBounds {
        return NMGLatLngBounds(latLngs: locations)
    }
    
    /// 직전의 마커 생성을 취소하고 경로선도 제거
    func undo() {
        guard let lastMarker = self.markers.popLast() else { return }
        substractDistance(with: lastMarker.position)
        lastMarker.mapView = nil
    }
    
    /// 출발지 마커를 제외한 모든 마커 제거
    func removeMarkers() {
        while self.markers.count != 0 {
            undo()
        }
    }
    
    // 두 지점 사이의 거리(m) 추가
    private func addDistance(with newLocation: NMGLatLng) {
        let lastCLLoc = markersLatLngs.last?.toCLLocation()
        let newCLLoc = newLocation.toCLLocation()
        guard let distance = lastCLLoc?.distance(from: newCLLoc) else { return }
        pathDistance += distance
    }
    
    // 마지막 지점까지의 거리(m) 제거
    private func substractDistance(with targetLocation: NMGLatLng) {
        let lastCLLoc = markersLatLngs.last?.toCLLocation()
        let targetCLLoc = targetLocation.toCLLocation()
        guard let distance = lastCLLoc?.distance(from: targetCLLoc) else { return }
        pathDistance -= distance
        if pathDistance < 1 { pathDistance = 0 }
    }
    
    private func setMap() {
        // 카메라 대상 지점을 한반도로 고정
        map.mapView.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132)
        map.showLocationButton = false
        map.showScaleBar = false
        map.showZoomControls = false
        map.mapView.logoAlign = .rightTop
    }
    
    private func getLocationAuth() {
        DispatchQueue.global().async { [self] in
            if CLLocationManager.locationServicesEnabled() {
                print("위치 상태 On 상태")
                self.locationManager.startUpdatingLocation()
            } else {
                print("위치 상태 Off 상태")
            }
        }
    }
    
    private func setDelegate() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = CLLocationAccuracy.greatestFiniteMagnitude
        locationManager.requestWhenInUseAuthorization()
        
        map.mapView.addCameraDelegate(delegate: self)
        map.mapView.touchDelegate = self
    }
    
    private func setPathOverlay() {
        pathOverlay.width = 4
        pathOverlay.outlineWidth = 0
        pathOverlay.color = .m1
    }
    
    private func setLocationOverlay() {
        let locationOverlay = map.mapView.locationOverlay
        locationOverlay.icon = locationOverlayIcon
    }
}

// MARK: - UI & Layout

extension RNMapView {
    private func setUI() {
        self.backgroundColor = .white
        self.locationButton.setImage(ImageLiterals.icMapLocation, for: .normal)
        self.locationButton.isHidden = true
        self.locationButton.addTarget(self, action: #selector(locationButtonDidTap), for: .touchUpInside)
    }
    
    private func setLayout() {
        addSubviews(map, locationButton)
        
        map.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        locationButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(88+bottomPadding)
            make.trailing.equalToSuperview().inset(12)
        }
    }
    
    private func updateSubviewsConstraints() {
        [locationButton].forEach { view in
            view.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(98+bottomPadding)
            }
        }
    }
}

// MARK: - @objc Function

extension RNMapView {
    @objc func locationButtonDidTap() {
        self.setPositionMode(mode: .direction)
    }
}

// MARK: - NMFMapViewCameraDelegate, NMFMapViewTouchDelegate

extension RNMapView: NMFMapViewCameraDelegate, NMFMapViewTouchDelegate {
    // 지도 탭 이벤트
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        guard isDrawMode && markers.count < 19 else { return }
        self.makeMarker(at: latlng)
    }
    
    // 지도 이동 멈췄을 때 호출되는 메서드
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let latitude = mapView.cameraPosition.target.lat
        let longitude = mapView.cameraPosition.target.lng

        eventSubject.send([latitude, longitude])
    }
}

extension RNMapView: CLLocationManagerDelegate {}

extension RNMapView {
    func cropImage(inputImage image: UIImage) -> UIImage? {
        let y = screenHeight > 800 ? screenHeight/4 + 150 : screenHeight/4 - 40
        return UIImage.cropImage(image, toRect: CGRect(x: 0, y: y, width: screenWidth*2, height: 500.adjustedH), viewWidth: screenWidth, viewHeight: 400.adjustedH)
    }
}
