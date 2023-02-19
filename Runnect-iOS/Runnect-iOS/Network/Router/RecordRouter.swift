//
//  RecordRouter.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/02/16.
//

import Foundation

import Moya

enum RecordRouter {
    case recordRunning(param: RunningRecordRequestDto)
}

extension RecordRouter: TargetType {
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .recordRunning:
            return .post
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
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .recordRunning:
            return Config.headerWithDeviceId
        }
    }
}
