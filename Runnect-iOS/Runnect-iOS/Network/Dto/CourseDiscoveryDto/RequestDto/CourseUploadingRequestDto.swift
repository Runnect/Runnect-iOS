//
//  CourseUploadingRequestDto.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/11.
//

import Foundation

// MARK: - CourseUploadingRequestDto

struct CourseUploadingRequestDto: Codable {
    let courseID: Int
    let title, description: String
}
