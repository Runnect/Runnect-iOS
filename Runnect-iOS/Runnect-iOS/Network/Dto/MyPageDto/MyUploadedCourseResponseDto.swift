//
//  MyUploadedCourseResponseDto.swift
//  Runnect-iOS
//
//  Created by 이명진 on 12/16/23.
//

import Foundation

// MARK: - MyUploadedCourseResponseDto
struct MyUploadedCourseResponseDto: Codable {
    let user: MyPage
    let publicCourses: [PublicCourse]
}

// MARK: - MyPage
struct MyPage: Codable {
    let id: Int
}
