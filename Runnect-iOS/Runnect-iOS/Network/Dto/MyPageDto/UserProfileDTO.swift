//
//  UserProfileDTO.swift
//  Runnect-iOS
//
//  Created by 이명진 on 2023/10/14.
//

import Foundation

// MARK: - UserProfileDto
struct UserProfileDto {
    let user: UserInfo
    let courses: [UserCourseInfo]
}

// MARK: - UserInfo
struct UserInfo {
    let nickname, latestStamp: String
    let level, levelPercent: Int
}

// MARK: - UserCourseInfo
struct UserCourseInfo {
    let publicCourseId, courseId: Int
    let title: String
    let image: String
    let departure: Departure
    let scrapTF: Bool
}

// MARK: - Departure
struct Departure {
    let region, city, town: String
    let detail: String?
    let name: String
}
