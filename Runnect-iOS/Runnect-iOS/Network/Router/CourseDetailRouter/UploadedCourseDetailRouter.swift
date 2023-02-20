//
//  UploadedCourseDetailRouter.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/12.
//

import Foundation

import Moya

enum UploadedCourseDetailRouter {
    case getUploadedCourseDetail(publicCourseId: Int)
}

extension UploadedCourseDetailRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .getUploadedCourseDetail(let publicCourseId):
            return "/public-course/detail/\(publicCourseId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUploadedCourseDetail:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUploadedCourseDetail:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getUploadedCourseDetail:
            return Config.headerWithDeviceId
        }
    }
}
