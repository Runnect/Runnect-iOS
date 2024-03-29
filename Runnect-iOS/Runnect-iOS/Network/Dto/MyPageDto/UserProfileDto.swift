//
//  UserProfileDto.swift
//  Runnect-iOS
//
//  Created by 이명진 on 12/10/23.
//

import Foundation

// MARK: - UserProfileDto
struct UserProfileDto: Codable {
    let user: UserInfo
    let courses: [UserCourseInfo]
}

// MARK: - UserInfo
struct UserInfo: Codable {
    let userId: Int
    let nickname, latestStamp: String
    let level, levelPercent: Int
}

// MARK: - UserCourseInfo
struct UserCourseInfo: Codable {
    let publicCourseId, courseId: Int
    let title: String
    let image: String
    let departure: Departure
    let scrapTF: Bool
}

// MARK: - Departure
struct Departure: Codable {
    let region, city, town: String
    let detail: String?
    let name: String?
}
