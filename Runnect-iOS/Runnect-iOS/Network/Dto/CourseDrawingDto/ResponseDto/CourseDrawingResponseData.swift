//
//  CourseDrawingResponseData.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/10.
//

import Foundation

// MARK: - DataClass

struct CourseDrawingResponseData: Codable {
    let course: CourseDrawingResponse
}

// MARK: - Course

struct CourseDrawingResponse: Codable {
    let id: Int
    let createdAt: String
}
