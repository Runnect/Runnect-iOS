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
    
    let pathImage = PassthroughSubject<UIImage, Never>()
    var cancelBag = Set<AnyCancellable>()
    
    let locationManager = CLLocationManager()
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
        setUI()
        setLayout()
        setDelegate()
        setMap()
        getLocationAuth()
        setPathOverlay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setDelegate()
        setMap()
        getLocationAuth()
        setPathOverlay()
        setLocationOverlay()
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
    func makeStartMarker(at location: NMGLatLng, withCameraMove: Bool = false) -> Self {
        self.startMarker.position = location
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
    func makeMarkersWithStartMarker(at locations: [NMGLatLng]) -> Self {
        if locations.count < 2 { return self }
        makeStartMarker(at: locations[0], withCameraMove: true)
        locations[1...].forEach { location in
            makeMarker(at: location)
        }
        return self
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
    
    /// 경로 뷰를 UIImage로 변환하여 pathImage에 send
    func getPathImage() {
        let bounds = makeMBR()
        let dummyMap = RNMapView(frame: CGRect(x: 50, y: 50, width: 300, height: 250))
            .makeMarkersWithStartMarker(at: self.markersLatLngs)
        addSubview(dummyMap)
        sendSubviewToBack(dummyMap)
        let cameraUpdate = NMFCameraUpdate(fit: bounds, padding: 150)
        cameraUpdate.animation = .none
        dummyMap.map.mapView.moveCamera(cameraUpdate)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.pathImage.send(UIImage(view: dummyMap.map.mapView))
        }
    }
    
    /// 바운더리(MBR) 생성
    func makeMBR() -> NMGLatLngBounds {
        var latitudes = [Double]()
        var longitudes = [Double]()
        self.markersLatLngs.forEach { latLng in
            latitudes.append(latLng.lat)
            longitudes.append(latLng.lng)
        }
        
        let southWest = NMGLatLng(lat: latitudes.min() ?? 0, lng: longitudes.min() ?? 0)
        let northEast = NMGLatLng(lat: latitudes.max() ?? 0, lng: longitudes.max() ?? 0)
        return NMGLatLngBounds(southWest: southWest, northEast: northEast)
    }
    
    /// 직전의 마커 생성을 취소하고 경로선도 제거
    func undo() {
        guard let lastMarker = self.markers.popLast() else { return }
        substractDistance(with: lastMarker.position)
        lastMarker.mapView = nil
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
            make.bottom.equalToSuperview().inset(98+bottomPadding)
            make.trailing.equalToSuperview().inset(24)
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

    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        let locationOverlay = map.mapView.locationOverlay
        if locationOverlay.icon != locationOverlayIcon {
            setLocationOverlay()
        }
    }
}

extension RNMapView: CLLocationManagerDelegate {}
