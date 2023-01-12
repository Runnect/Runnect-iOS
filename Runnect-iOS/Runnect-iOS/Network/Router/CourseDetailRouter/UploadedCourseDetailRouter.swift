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
    case createAndDeleteScrap(publicCourseId: Int, scrapTF: Bool)
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
        case .createAndDeleteScrap:
            return "/scrap"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUploadedCourseDetail:
            return .get
        case .createAndDeleteScrap:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUploadedCourseDetail:
            return .requestPlain
        case .createAndDeleteScrap(let publicCourseId, let scrapTF):
            return .requestParameters(parameters: ["publicCourseId": publicCourseId, "scrapTF": scrapTF], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getUploadedCourseDetail, .createAndDeleteScrap:
            return Config.headerWithDeviceId
        }
    }
}
