//
//  AuthRouter.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/03/25.
//

import Foundation

import Moya

enum AuthRouter {
    case getUserInfo
}

extension AuthRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .getUserInfo:
            return "api/auth"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUserInfo:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getUserInfo:
            return Config.headerWithDeviceId
        }
    }
}
