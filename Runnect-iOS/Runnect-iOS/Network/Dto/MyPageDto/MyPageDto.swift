//
//  MyPageDto.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/10.
//

import Foundation

// MARK: - MyPageDto
struct MyPageDto: Codable {
    let user: User
}

// MARK: - User
struct User: Codable {
    let machineID, nickname, latestStamp: String
    let level, levelPercent: Int

    enum CodingKeys: String, CodingKey {
        case machineID = "machineId"
        case nickname, latestStamp, level, levelPercent
    }
}
