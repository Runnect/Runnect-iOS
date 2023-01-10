//
//  CourseDetailResponseDto.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/10.
//

import Foundation

typealias Course = PrivateCourse
typealias CourseDeparture = PrivateCourseDeparture

// MARK: - CourseDetailResponseDto

struct CourseDetailResponseDto: Codable {
    let course: Course
}
