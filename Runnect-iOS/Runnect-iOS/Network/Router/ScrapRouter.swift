//
//  ScrapRouter.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/02/16.
//

import Foundation

import Moya

enum ScrapRouter {
    case createAndDeleteScrap(publicCourseId: Int, scrapTF: Bool)
    case getScrapCourse
}

extension ScrapRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .createAndDeleteScrap:
            return "/scrap"
        case .getScrapCourse:
            return "/scrap/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createAndDeleteScrap:
            return .post
        case .getScrapCourse:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createAndDeleteScrap(let publicCourseId, let scrapTF):
            return .requestParameters(parameters: ["publicCourseId": publicCourseId, "scrapTF": scrapTF], encoding: JSONEncoding.default)
        case .getScrapCourse:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .createAndDeleteScrap, .getScrapCourse:
            return Config.headerWithDeviceId
        }
    }
}
