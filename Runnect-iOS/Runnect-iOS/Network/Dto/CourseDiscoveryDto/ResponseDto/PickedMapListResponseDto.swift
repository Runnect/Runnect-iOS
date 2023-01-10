//
//  CourseDiscoveryResponsDto.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/10.
//

import Foundation

// MARK: - DataClass

struct PickedMapListResponseDto: Codable {
    let publicCourses: [PublicCourse]
}

// MARK: - PublicCourse

struct PublicCourse: Codable {
    let id, courseId: Int
    let title: String
    let image: String
    let scarp: Bool
    let departure: CourseDiscoveryDeparture
}

// MARK: - Departure

struct CourseDiscoveryDeparture: Codable {
    let region: String
    let city: String
}
