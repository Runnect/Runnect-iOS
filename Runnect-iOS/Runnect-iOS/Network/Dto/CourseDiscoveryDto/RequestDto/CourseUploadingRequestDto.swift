//
//  CourseUploadingRequestDto.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/11.
//

import Foundation

// MARK: - CourseUploadingRequestDto

struct CourseUploadingRequestDto: Codable {
    let courseId: Int
    let title, description: String
}
