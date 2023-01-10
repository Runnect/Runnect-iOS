//
//  CourseStorageRouter.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/10.
//

import Foundation

import Moya

enum CourseStorageRouter {
    case getAllPrivateCourse
}

extension CourseStorageRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .getAllPrivateCourse:
            return "/course/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllPrivateCourse:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAllPrivateCourse:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getAllPrivateCourse:
            return Config.headerWithDeviceId
        }
    }
}
