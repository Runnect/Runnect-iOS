//
//  UserManager.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/03/25.
//

import Foundation

import Moya

enum RNError: Error {
    case networkFail
    case etc
}

final class UserManager {
    static let shared = UserManager()
    
    private var signInProvider = MoyaProvider<AuthRouter>(
        plugins: [NetworkLoggerPlugin(verbose: true)]
    )
    
    @UserDefaultWrapper<String>(key: "accessToken") public var accessToken
    @UserDefaultWrapper<String>(key: "refreshToken") public var refreshToken
    @UserDefaultWrapper<Bool>(key: "isKakao") public var isKakao
    var hasAccessToken: Bool { return self.accessToken != nil }
    
    private init() {}
    
    func updateToken(accessToken: String, refreshToken: String, isKakao: Bool) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.isKakao = isKakao
    }
    
    func signIn(token: String, provider: String, completion: @escaping(Result<String, RNError>) -> Void) {
        signInProvider.request(.signIn(token: token, provider: provider)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<SignInResponseDto>.self)
                        guard let data = responseDto.data else { return }
                        self.accessToken = data.data.accessToken
                        self.refreshToken = data.data.refreshToken
                        self.isKakao = provider == "KAKAO" ? true : false
                        completion(.success(data.data.nickname))
                    } catch {
                        print(error.localizedDescription)
                        completion(.failure(.networkFail))
                    }
                }
                if status >= 400 {
                    print("400 error")
                    completion(.failure(.networkFail))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(.networkFail))
            }
        }
    }
    
    func autoSignIn(completion: @escaping(Result<String, RNError>) -> Void) {
        guard let accessToken = self.accessToken else { return }
        guard let isKakao = self.isKakao else { return }
        let provider = isKakao ? "KAKAO" : "APPLE"
        signInProvider.request(.signIn(token: accessToken, provider: provider)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<SignInResponseDto>.self)
                        guard let data = responseDto.data else { return }
                        self.accessToken = data.data.accessToken
                        self.refreshToken = data.data.refreshToken
                        self.isKakao = provider == "KAKAO" ? true : false
                        completion(.success(data.data.nickname))
                    } catch {
                        print(error.localizedDescription)
                        completion(.failure(.networkFail))
                    }
                }
                if status >= 400 {
                    print("400 error")
                    completion(.failure(.networkFail))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(.networkFail))
            }
        }
    }
}
