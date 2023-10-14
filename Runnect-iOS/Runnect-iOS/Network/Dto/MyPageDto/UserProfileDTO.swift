//
//  UserProfileDTO.swift
//  Runnect-iOS
//
//  Created by 이명진 on 2023/10/14.
//

import Foundation

// MARK: - DataClass
struct UserProfileDto {
    let user: UserInfo
    let courses: [CourseInfo]
}

// MARK: - Course
struct CourseInfo {
    let publicCourseID, courseID: Int
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

// MARK: - User
struct UserInfo {
    let nickname, latestStamp: String
    let level, levelPercent: Int
}
