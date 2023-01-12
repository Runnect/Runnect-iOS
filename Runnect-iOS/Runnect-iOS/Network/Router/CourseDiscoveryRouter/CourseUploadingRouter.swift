//
//  CourseUploadingRouter.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/11.
//

import Foundation

import Moya

enum CourseUploadingRouter {
    case courseUploadingData(param: CourseUploadingRequestDto)
}
 
extension CourseUploadingRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .courseUploadingData:
            return "/public-course"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .courseUploadingData:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .courseUploadingData(param: let param):
            return .requestParameters(parameters: try! param.asParameter(), encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .courseUploadingData:
            return Config.headerWithDeviceId
        }
    }
    
}
