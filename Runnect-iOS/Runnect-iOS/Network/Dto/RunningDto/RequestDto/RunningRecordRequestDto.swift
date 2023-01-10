//
//  RunningRecordRequestDto.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/10.
//

import Foundation

// MARK: - RunningRecordRequestDto

struct RunningRecordRequestDto: Codable {
    let courseId: Int
    let publicCourseId: Int?
    let title, time, pace: String
}
