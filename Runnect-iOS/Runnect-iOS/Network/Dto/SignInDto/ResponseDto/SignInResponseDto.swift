//
//  SignInResponseDto.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/03/25.
//

import Foundation

// MARK: - SignInResponseDto

struct SignInResponseDto: Codable {
    let type, accessToken: String
    let nickname: String?
    let email: String?
    let refreshToken: String
}
