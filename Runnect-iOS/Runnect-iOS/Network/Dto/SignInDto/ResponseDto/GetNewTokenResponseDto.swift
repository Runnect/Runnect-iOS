//
//  GetNewTokenResponseDto.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/04/03.
//

import Foundation

// MARK: - GetNewTokenResponseDto

struct GetNewTokenResponseDto: Codable {
    let accessToken: String
    let refreshToken: String
}
