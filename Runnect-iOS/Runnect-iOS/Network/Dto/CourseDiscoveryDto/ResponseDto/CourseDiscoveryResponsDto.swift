//
//  CourseDiscoveryResponsDto.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/10.
//

import Foundation

// MARK: - CourseDiscoveryResponseDto
struct CourseDiscoveryResponseDto: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let publicCourses: [PublicCourse]
}

// MARK: - PublicCourse
struct PublicCourse: Codable {
    let id, courseID: Int
    let title: String
    let image: String
    let scarp: Bool
    let departure: Departure

    enum CodingKeys: String, CodingKey {
        case id
        case courseID = "courseId"
        case title, image, scarp, departure
    }
}

// MARK: - Departure
struct Departure: Codable {
    let region: Region
    let city: String
}

enum Region: String, Codable {
    case 서울 = "서울"
    case 전북 = "전북"
}
