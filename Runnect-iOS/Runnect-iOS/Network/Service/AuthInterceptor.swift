//
//  AuthInterceptor.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/04/04.
//

import Foundation

import Alamofire
import Moya

final class AuthRetrier: Retrier {
    
    static let shared = AuthRetrier()
    
    private init() {
        super.init { request, _, error, completion in
            print("인잇")
            guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
                completion(.doNotRetry)
                return
            }
            UserManager.shared.getNewToken { result in
                switch result {
                case .success:
                    print("토큰 재발급 성공")
                    completion(.retry)
                case .failure(let error):
                    print("실패실패")
                    completion(.doNotRetryWithError(error))
                }
            }
        }
    }
}

/// 토큰 만료 시 자동으로 refresh를 위한 서버 통신
final class AuthInterceptor: RequestInterceptor {
    
    static let shared = AuthInterceptor()
    
    private init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        UserManager.shared.getNewToken { result in
            switch result {
            case .success:
                print("토큰 재발급 성공")
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
