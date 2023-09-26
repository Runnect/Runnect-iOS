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
    case getLocationAddress(latitude: Double, longitude: Double)
}

extension DepartureSearchingRouter: TargetType {
    var baseURL: URL {
        var urlString: String
        
        switch self {
        case .getAddress(let keyword):
            urlString = Config.kakaoAddressBaseURL
        case .getLocationAddress:
            urlString = "https://dapi.kakao.com/v2/local/geo"
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAddress, .getLocationAddress:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAddress(let keyword):
            return .requestParameters(parameters: ["query": keyword], encoding: URLEncoding.default)
        case .getLocationAddress(let latitude, let longitude):
            return .requestParameters(parameters: ["x": longitude, "y": latitude], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json",
                "Authorization": "KakaoAK \(Config.kakaoRestAPIKey)"]
    }
}
