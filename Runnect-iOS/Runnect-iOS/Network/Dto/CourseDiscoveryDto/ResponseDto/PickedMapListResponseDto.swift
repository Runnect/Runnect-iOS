//
//  CourseDiscoveryResponsDto.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/10.
//

import Foundation

// MARK: - PickedMapListResponseDto

struct PickedMapListResponseDto: Codable {
    let publicCourses: [PublicCourse]
}

// MARK: - PublicCourse

struct PublicCourse: Codable {
    let id, courseId: Int
    let title: String
    let image: String
    let scrap: Bool?
    let description: String?
    let distance: Float?
    let departure: CourseDiscoveryDeparture
}

// MARK: - CourseDiscoveryDeparture

struct CourseDiscoveryDeparture: Codable {
    let region: String
    let city: String
    let town: String?
    let name: String?
}
