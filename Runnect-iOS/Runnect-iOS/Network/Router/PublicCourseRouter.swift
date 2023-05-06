//
//  PublicCourseRouter.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/02/16.
//

import Foundation
import Moya

enum PublicCourseRouter {
    case getCourseData
    case getCourseSearchData(keyword: String)
    case courseUploadingData(param: CourseUploadingRequestDto)
    case getUploadedCourseDetail(publicCourseId: Int)
    case getUploadedCourseInfo
    case updatePublicCourse(publicCourseId: Int, editCourseRequestDto: EditCourseRequestDto)
}     

extension PublicCourseRouter: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {fatalError("baseURL could not be configured")
        }
        return url
        
    }
    
    var path: String {
        switch self {
        case .getCourseData, .courseUploadingData:
            return "/public-course"
        case .getCourseSearchData:
            return "/public-course/search"
        case .getUploadedCourseDetail(let publicCourseId):
            return "/public-course/detail/\(publicCourseId)"
        case .getUploadedCourseInfo:
            return "/public-course/user"
        case .updatePublicCourse(let publicCourseId, _):
            return "/public-course/\(publicCourseId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCourseData, .getCourseSearchData, .getUploadedCourseDetail, .getUploadedCourseInfo:
            return .get
        case .courseUploadingData:
            return .post
        case .updatePublicCourse:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCourseSearchData(let keyword):
            return .requestParameters(parameters: ["keyword": keyword], encoding: URLEncoding.default)
        case .courseUploadingData(param: let param):
            do {
                return .requestParameters(parameters: try param.asParameter(), encoding: JSONEncoding.default)
            } catch {
                fatalError("Encoding 실패")}
        case .updatePublicCourse(_, let param):
            do {
                return .requestParameters(parameters: try param.asParameter(), encoding: JSONEncoding.default)
            } catch {
                fatalError("Encoding 실패")}
        case .getCourseData, .getUploadedCourseDetail, .getUploadedCourseInfo:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return Config.defaultHeader
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
