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
    case getUploadedCourseInfo
    case getActivityRecordInfo
    case getGoalRewardInfo
    case updateUserNickname(nickname: String)
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
        case .getMyPageInfo, .updateUserNickname:
            return "/user"
        case .getUploadedCourseInfo:
            return "/public-course/user"
        case .getActivityRecordInfo:
            return "/record/user"
        case .getGoalRewardInfo:
            return "/stamp/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyPageInfo, .getUploadedCourseInfo, .getActivityRecordInfo, .getGoalRewardInfo:
            return .get
        case .updateUserNickname:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyPageInfo, .getUploadedCourseInfo, .getActivityRecordInfo, .getGoalRewardInfo:
            return .requestPlain
        case .updateUserNickname(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getMyPageInfo, .getUploadedCourseInfo, .getActivityRecordInfo, .getGoalRewardInfo, .updateUserNickname:
            return ["Content-Type": "application/json",
                    "machineId": "1"]
        }
    }
}
