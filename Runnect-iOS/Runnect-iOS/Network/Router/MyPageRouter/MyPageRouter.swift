//
//  MyPageRouter.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/10.
//

import Foundation

import Moya

enum MyPageRouter {
    case getMyPageInfo
}

extension MyPageRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .getMyPageInfo:
            return "/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyPageInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyPageInfo:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getMyPageInfo:
            return Config.headerWithDeviceId
        }
    }
}
