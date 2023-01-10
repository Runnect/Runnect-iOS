//
//  RunningRouter.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/10.
//

import Foundation

import Moya

enum RunningRouter {
    case recordRunning(param: RunningRecordRequestDto)
    case getCourseDetail(courseId: Int)
}

extension RunningRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .recordRunning:
            return "/record"
        case .getCourseDetail(let courseId):
            return "/course/detail/\(courseId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .recordRunning:
            return .post
        case .getCourseDetail:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .recordRunning(let param):
            do {
                return .requestParameters(parameters: try param.asParameter(), encoding: JSONEncoding.default)
            } catch {
                fatalError(error.localizedDescription)
            }
        case .getCourseDetail:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .recordRunning, .getCourseDetail:
            return Config.headerWithDeviceId
        }
    }
}
