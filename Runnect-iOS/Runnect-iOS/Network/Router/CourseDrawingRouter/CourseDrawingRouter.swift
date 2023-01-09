//
//  CourseDrawingRouter.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/10.
//

import Foundation

import Moya

enum CourseDrawingRouter {
    case uploadCourseDrawing(param: CourseDrawingRequestDto)
}

extension CourseDrawingRouter: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .uploadCourseDrawing:
            return "/course"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .uploadCourseDrawing:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .uploadCourseDrawing(let param):
            var multipartFormData: [MultipartFormData] = []
            
            let imageData = MultipartFormData(provider: .data(param.image),
                                              name: "image", fileName: "image.jpeg",
                                              mimeType: "image/jpeg")
            
            multipartFormData.append(imageData)
            
            var content = [String: Any]()
            
            var path = [[String: Any]]()
            
            for location in param.data.path {
                let locationData = try! location.asParameter()
                path.append(locationData)
            }
            
            content["path"] = path
            content["distance"] = param.data.distance
            content["departureAddress"] = param.data.departureAddress
            content["departureName"] = param.data.departureName
            
            let jsonData = try! JSONSerialization.data(withJSONObject: content)
            let formData = MultipartFormData(provider: .data(jsonData), name: "data", mimeType: "application/json")
            multipartFormData.append(formData)
            
            return .uploadMultipart(multipartFormData)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .uploadCourseDrawing:
            return ["Content-Type": "multipart/form-data",
                    "machineId": Config.deviceId]
        }
    }
}
