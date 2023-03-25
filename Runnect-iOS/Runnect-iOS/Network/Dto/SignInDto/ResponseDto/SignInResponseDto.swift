//
//  SignInResponseDto.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/03/25.
//

import Foundation

// MARK: - SignInResponseDto

struct SignInResponseDto: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: SignInResponseData
}

// MARK: - SignInResponseData
struct SignInResponseData: Codable {
    let type, email, nickname, accessToken: String
    let refreshToken: String
}
