//
//  CourseStorageRouter.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/10.
//

import Foundation

import Moya

enum CourseStorageRouter {
    case getPrivateCourseNotUploaded
    case getScrapCourse
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
        case .getPrivateCourseNotUploaded:
            return "/course/private/user"
        case .getScrapCourse:
            return "/scrap/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPrivateCourseNotUploaded, .getScrapCourse:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getPrivateCourseNotUploaded, .getScrapCourse:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getPrivateCourseNotUploaded, .getScrapCourse:
            return Config.headerWithDeviceId
        }
    }
}
