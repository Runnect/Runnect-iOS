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
    
    private var authProvider = MoyaProvider<AuthRouter>(
        session: Moya.Session(interceptor: AuthRetrier.shared),
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
        authProvider.request(.signIn(token: token, provider: provider)) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<SignInResponseDto>.self)
                        guard let data = responseDto.data else { return }
                        self.accessToken = data.accessToken
                        self.refreshToken = data.refreshToken
                        self.isKakao = provider == "KAKAO" ? true : false
                        completion(.success(data.type)) // 로그인인지 회원가입인지 전달
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
    
    func getNewToken(completion: @escaping(Result<Bool, RNError>) -> Void) {
        authProvider.request(.getNewToken) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<GetNewTokenResponseDto>.self)
                        guard let data = responseDto.data else { return }
                        self.accessToken = data.accessToken
                        self.refreshToken = data.refreshToken
                        completion(.success(true))
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
