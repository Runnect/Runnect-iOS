//
//  MyPageRouter.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/10.
//

import Foundation

import Moya

enum MyPageRouter {
    case getUploadedCourseInfo
    case getGoalRewardInfo
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
        case .getUploadedCourseInfo:
            return "/public-course/user"
        case .getGoalRewardInfo:
            return "/stamp/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUploadedCourseInfo, .getGoalRewardInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUploadedCourseInfo, .getGoalRewardInfo:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getUploadedCourseInfo, .getGoalRewardInfo:
            return Config.headerWithDeviceId
        }
    }
}
