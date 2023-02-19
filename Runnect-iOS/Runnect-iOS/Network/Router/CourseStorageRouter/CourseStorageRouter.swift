//
//  CourseStorageRouter.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/10.
//

import Foundation

import Moya

enum CourseStorageRouter {
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
            
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        }
    }
    
    var task: Moya.Task {
        switch self {
            
        }
    }
    
    var headers: [String: String]? {
        switch self {
            
        }
    }
}
