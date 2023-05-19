//
//  UploadedCourseDetailResponseDto.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/12.
//

import Foundation

// MARK: - UploadedCourseDetailResponseDto

struct UploadedCourseDetailResponseDto: Codable {
    let user: UploadUser
    let publicCourse: PublicCourse
}

// MARK: - UploadUser

struct UploadUser: Codable {
    let nickname: String
    let level: String
    let image: String
    let isNowUser: Bool?
}
