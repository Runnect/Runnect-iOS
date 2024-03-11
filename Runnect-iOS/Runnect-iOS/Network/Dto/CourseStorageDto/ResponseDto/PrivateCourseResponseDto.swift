//
//  PrivateCourseResponseDto.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/10.
//

import Foundation

// MARK: - PrivateCourseResponseDto

struct PrivateCourseResponseDto: Codable {
    let courses: [PrivateCourse]
}

// MARK: - PrivateCourse

struct PrivateCourse: Codable {
    let id: Int
    let isNowUser: Bool?
    let title: String
    let image, createdAt: String
    let distance: Float?
    let path: [[Double]]?
    let departure: PrivateCourseDeparture
}

// MARK: - PrivateCourseDeparture

struct PrivateCourseDeparture: Codable {
    let region, city: String
    let town: String?
    let name: String?
}
