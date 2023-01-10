//
//  CourseDrawingRequestDto.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/10.
//

import Foundation

// MARK: - CourseDrawingRequestDto

struct CourseDrawingRequestDto: Codable {
    let image: Data
    let data: CourseDrawingRequestData
}

// MARK: - CourseDrawingRequestData

struct CourseDrawingRequestData: Codable {
    let path: [RNLocationModel]
    let distance: Float
    let departureAddress, departureName: String
}
