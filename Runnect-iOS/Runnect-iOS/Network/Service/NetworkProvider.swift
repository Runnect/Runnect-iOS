//
//  NetworkProvider.swift
//  Runnect-iOS
//
//  Created by Sojin Lee on 2023/11/14.
//

import Moya

class NetworkProvider<Provider : TargetType> : MoyaProvider<Provider> {
    func request<Model : Codable>(target : Provider, instance : Model.Type , vc: UIViewController, completion : @escaping(Model) -> ()){
        self.request(target) { result in
            switch result {
            /// 서버 통신 성공
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    if let decodeData = try? JSONDecoder().decode(instance, from: response.data) {
                        completion(decodeData)
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
                if let response = error.response {
                    if let responseData = String(data: response.data, encoding: .utf8) {
                        print(responseData)
                    } else {
                        print(error.localizedDescription)
                    }
                } else {
                    print(error.localizedDescription)
                }
                vc.showNetworkFailureToast()
            }
        }
    }
}
