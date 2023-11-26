//
//  MarathonListResponseDto.swift
//  Runnect-iOS
//
//  Created by 이명진 on 11/26/23.
//

import Foundation

// MARK: - MarathonListResponseDto

struct MarathonListResponseDto: Codable {
    let marathonPublicCourses: [marathonCourse]
}

// MARK: - PublicCourse

struct marathonCourse: Codable {
    let id, courseId: Int
    let title: String
    let image: String
    let scrap: Bool?
    let departure: Departure
}

// MARK: - CourseDiscoveryDeparture

struct Departure: Codable {
    let region: String
    let city: String
}
