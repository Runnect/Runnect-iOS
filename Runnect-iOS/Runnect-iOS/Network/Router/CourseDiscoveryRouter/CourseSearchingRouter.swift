//
//  CourseSearchingRouter.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/11.
//

import Foundation

import Moya

enum CourseSearchingRouter {
    case getCourseData(keyword: String)
}

extension CourseSearchingRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getCourseData:
            return "/public-course/search"
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
        case .getCourseData(let keyword):
            return .requestParameters(parameters: ["keyword": keyword], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getCourseData:
            return Config.headerWithDeviceId
        }
    }
}
