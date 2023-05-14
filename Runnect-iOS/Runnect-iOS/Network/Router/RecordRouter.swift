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
    case getActivityRecordInfo
    case deleteRecord(recordIdList: [Int])
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
        case .recordRunning, .deleteRecord:
            return "/record"
        case .getActivityRecordInfo:
            return "/record/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .recordRunning:
            return .post
        case .getActivityRecordInfo:
            return .get
        case .deleteRecord:
            return .put
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
        case .getActivityRecordInfo:
            return .requestPlain
        case .deleteRecord(let recordIdList):
            return .requestParameters(parameters: ["recordIdList": recordIdList], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .recordRunning, .getActivityRecordInfo, .deleteRecord:
            return Config.defaultHeader
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
