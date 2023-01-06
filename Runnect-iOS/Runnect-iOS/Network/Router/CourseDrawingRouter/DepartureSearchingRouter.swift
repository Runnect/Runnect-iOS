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
}

extension DepartureSearchingRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.kakaoAddressBaseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .getAddress:
            return "/keyword.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAddress:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAddress(let keyword):
            return .requestParameters(parameters: ["query": keyword], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json",
                "Authorization": "KakaoAK \(Config.kakaoRestAPIKey)"]
    }
}
