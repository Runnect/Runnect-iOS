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
    let path: [RNLocationModel]
    let title: String
    let distance: Float
    let departureAddress, departureName: String
}

//        "image" : 이미지 파일,
//        "path" :  [{lat : 실수(double), long : 실수},{lat : 실수(double), long : 실수},{lat : 실수(double), long : 실수} ],
//        "title" : "한강 공원 한 바퀴",
//        "distance" : 4.4,
//        "departureAddress" : "전북 익산시 삼성동 100",
//        "departureName" : "보리의 집"

// MARK: - CourseDrawingRequestData

struct CourseDrawingRequestData: Codable {
    let path: [RNLocationModel]
//    let title: String
    let distance: Float
    let departureAddress, departureName: String
}
