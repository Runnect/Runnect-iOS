//
//  SignInRouter.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/09.
//

import Foundation

import Moya

enum SignInRouter {
    case signUp(nickname: String)
}

extension SignInRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signUp(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .signUp:
            return Config.headerWithDeviceId
        }
    }
}
