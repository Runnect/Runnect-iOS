//
//  ActivityRecordInfoDto.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/11.
//

import Foundation

// MARK: - ActivityRecordInfoDto

struct ActivityRecordInfoDto: Codable {
    let records: [ActivityRecord]
}

// MARK: - Record

struct ActivityRecord: Codable {
    let id, courseId: Int
    let publicCourseId: Int?
    let title: String
    let image: String
    let createdAt: String
    let distance: Double
    let time, pace: String
    let departure: ActivityRecordDeparture
}

// MARK: - Departure

struct ActivityRecordDeparture: Codable {
    let region, city: String
}
