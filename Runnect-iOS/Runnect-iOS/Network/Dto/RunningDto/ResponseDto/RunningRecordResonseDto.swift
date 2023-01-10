//
//  RunningRecordResonseDto.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/10.
//

import Foundation

// MARK: - RunningRecordResonseDto

struct RunningRecordResonseDto: Codable {
    let record: RunningRecordResonseData
}

// MARK: - RunningRecordResonseData

struct RunningRecordResonseData: Codable {
    let id: Int
    let createdAt: String
}
