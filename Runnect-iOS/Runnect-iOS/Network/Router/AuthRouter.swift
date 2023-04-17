//
//  AuthRouter.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/03/25.
//

import Foundation

import Moya

enum AuthRouter {
    case signIn(token: String, provider: String)
    case getNewToken
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
        case .signIn:
            return "/auth"
        case .getNewToken:
            return "/auth/getNewToken"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn:
            return .post
        case .getNewToken:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signIn(let token, let provider):
            return .requestParameters(parameters: ["token": token, "provider": provider], encoding: JSONEncoding.default)
        case .getNewToken:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .signIn, .getNewToken:
            return Config.defaultHeader
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
