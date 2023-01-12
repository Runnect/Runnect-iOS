//
//  GoalRewardInfoDto.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/11.
//

import Foundation

// MARK: - GoalRewardInfoDto

struct GoalRewardInfoDto: Codable {
    let stamps: [GoalRewardStamp]
}

// MARK: - GoalRewardStamp

struct GoalRewardStamp: Codable {
    let id: String
}
