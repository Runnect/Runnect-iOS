//
//  DepartureSearchingRouter.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/06.
//

import Foundation

import Moya

enum DepartureSearchingRouter {
    case getAddress(keyword: String)
    case getLocationAddress(latitude: Double, longitude: Double) // kakao
    case getLocationTmapAddress(latitude: Double, longitude: Double) // tmap
}

/// 현재 위치 | 검색 | 지도에서 선택 중 분기처리를 해주기 위함
enum SelectedType {
    case other
    case map
}

final class SelectedInfo {
    static let shared = SelectedInfo()
    var type: SelectedType = .other
    
    private init() {}
}

extension DepartureSearchingRouter: TargetType {
    var baseURL: URL {
        var urlString: String
        
        switch self {
        case .getAddress:
            urlString = Config.kakaoAddressBaseURL
        case .getLocationAddress:
            urlString = "https://dapi.kakao.com/v2/local/geo"
        case .getLocationTmapAddress:
            urlString = Config.tmapAddressBaseURL
        }
        
        guard let url = URL(string: urlString) else {
            fatalError("baseURL could not be configured")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getAddress:
            return "/keyword.json"
        case .getLocationAddress:
            return "/coord2address.json"
        case .getLocationTmapAddress:
            return "/reversegeocoding"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAddress, .getLocationAddress, .getLocationTmapAddress:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAddress(let keyword):
            return .requestParameters(parameters: ["query": keyword], encoding: URLEncoding.default)
        case .getLocationAddress(let latitude, let longitude): // 사용하지 않습니다.
            return .requestParameters(parameters: ["x": longitude, "y": latitude], encoding: URLEncoding.default)
        case .getLocationTmapAddress(let latitude, let longitude):
            return .requestParameters(parameters: ["lat": latitude, "lon": longitude, "addressType": "A04", "appKey": Config.tmapAPIKey], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json",
                "Authorization": "KakaoAK \(Config.kakaoRestAPIKey)"]
    }
}
