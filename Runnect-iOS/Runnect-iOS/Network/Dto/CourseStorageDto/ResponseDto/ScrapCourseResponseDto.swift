//
//  ScrapCourseResponseDto.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/11.
//

import Foundation

// MARK: - ScrapCourseResponseDto

struct ScrapCourseResponseDto: Codable {
    let scraps: [ScrapCourse]
}

// MARK: - ScrapCourse

struct ScrapCourse: Codable {
    let id, publicCourseId, courseId: Int
    let title: String
    let image: String
    let departure: ScrapCourseDeparture
}

// MARK: - ScrapCourseDeparture

struct ScrapCourseDeparture: Codable {
    let region, city: String
}
