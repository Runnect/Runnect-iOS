//
//  StampRouter.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/02/16.
//

import Foundation

import Moya

enum StampRouter {
    case getGoalRewardInfo
}

extension StampRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .getGoalRewardInfo:
            return "/stamp/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getGoalRewardInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getGoalRewardInfo:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getGoalRewardInfo:
            return Config.headerWithDeviceId
        }
    } 
}
