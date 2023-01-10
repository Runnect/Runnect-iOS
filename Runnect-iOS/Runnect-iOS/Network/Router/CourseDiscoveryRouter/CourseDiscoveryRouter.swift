//
//  pickedMapListRouter.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/10.
//

import Foundation

import Moya

enum pickedMapListRouter {
    case getCourseData
}

extension pickedMapListRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .getCourseData:
            return "/public-course"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCourseData:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCourseData:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getCourseData:
            return Config.headerWithDeviceId
        }
    }
}
