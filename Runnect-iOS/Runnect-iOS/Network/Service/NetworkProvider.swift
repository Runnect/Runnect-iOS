//
//  NetworkProvider.swift
//  Runnect-iOS
//
//  Created by Sojin Lee on 2023/11/14.
//

import Moya

enum ResponseResult<T> {
    case success(T)
}

class NetworkProvider<Provider : TargetType> : MoyaProvider<Provider> {
    func request<Model : Codable>(target : Provider, instance : Model.Type , vc: UIViewController, completion : @escaping(ResponseResult<Model>) -> ()){
        self.request(target) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    if let decodeData = try? JSONDecoder().decode(instance, from: response.data) {
                        completion(.success(decodeData))
                    } else{
                        /// decoding error
                        vc.showNetworkFailureToast()
                    }
                } else {
                    /// 응답 코드 400인 경우
                    vc.showNetworkFailureToast()
                }
            /// 서버 통신 실패
            case .failure(let error):
                print(error.errorDescription)
                vc.showNetworkFailureToast()
            }
        }
    }
}
