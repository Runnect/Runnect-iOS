//
//  UserRouter.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/02/16.
//

import Foundation

import Moya

enum UserRouter {
    case getMyPageInfo
    case getUserProfileInfo(userId: Int)
    case updateUserNickname(nickname: String)
    case deleteUser(appleToken: String?)
}

extension UserRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .getMyPageInfo, .updateUserNickname, .deleteUser:
            return "/user"
        case .getUserProfileInfo(let userId):
            return "/user/\(userId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyPageInfo, .getUserProfileInfo:
            return .get
        case .updateUserNickname:
            return .patch
        case .deleteUser:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyPageInfo, .getUserProfileInfo, .deleteUser:
            return .requestPlain
        case .updateUserNickname(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .deleteUser(let appleToken):
            if let appleToken = appleToken {
                return ["Content-Type": "application/json", "appleAccessToken": appleToken]
            } else {
                return Config.defaultHeader
            }
        default:
            return Config.defaultHeader
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
